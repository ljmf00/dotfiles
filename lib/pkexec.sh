#!/usr/bin/env bash

# set safe failures
set -euo pipefail

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  SCRIPT_FOLDER="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$SCRIPT_FOLDER/$SOURCE"
done
SCRIPT_FOLDER="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
unset SOURCE

[ -n "${_dotfiles_lib_pkexec_source_guard+x}" ] \
    && return                                   \
    || _dotfiles_lib_pkexec_source_guard=

###############################################################################

source "$SCRIPT_FOLDER/utility.sh"

function _pkexec_open_pipe()
{
    tail -f /dev/null | tail -f /dev/null &

    local pid2="$!"
    local pid1=
    pid1="$(jobs -p %+)"

    exec 3>"/proc/$pid1/fd/1" 4<"/proc/$pid2/fd/0"

    disown "$pid2"
    kill "$pid1" "$pid2"
}

function _pkexec_close_pipe()
{
    >&3 cat<<< exit
    exec 3>&- 4<&-

    if [ -n "${_pkexec_pkexec_pid+x}" ]; then
        wait "$_pkexec_pkexec_pid"
        unset _pkexec_pkexec_pid
    fi
}

function _pkexec_ensure_daemon()
{
    if [ -z "${_pkexec_pkexec_pid+x}" ]; then
        if [ "${DISPLAY:-}" != "" ] && type -P pkexec; then
            \command pkexec bash -rc "while read -r cmd; do \$cmd; done" <&4 &
            _pkexec_pkexec_pid="$!"
        elif type -P sudo; then
            env -i sudo -kb -- bash -rc "while read -r cmd; do \$cmd; done" <&4
            _pkexec_pkexec_pid="$!"
        else
            echo "No suitable su executor" >&1
            exit 1
        fi

        trap_add _pkexec_close_pipe EXIT
    fi
}

function pkexec()
{
    if { :>&3; } 2> /dev/null || _pkexec_open_pipe; then
        >&3 cat<<<"$@"
        _pkexec_ensure_daemon

        return
    fi

    # use sudo normally otherwise
    env -i sudo -- bash -rc "$*"
}

#shellcheck disable=SC2015
(return 0 2>/dev/null) && : || pkexec "$@"
