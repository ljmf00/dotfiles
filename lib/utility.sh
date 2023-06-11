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

[ -n "${_dotfiles_lib_utility_source_guard+x}" ] \
    && return                                   \
    || _dotfiles_lib_utility_source_guard=

###############################################################################

error() { echo "${BASH_SOURCE[0]}: error: $*" >&2; }
fatal() { error "$@"; exit 1; }

# appends a command to a trap
#
# - 1st arg:  code to add
# - remaining args:  names of traps to modify
#
function trap_add()
{
    # shellcheck disable=SC2128
    local trap_add_cmd="$1"; shift || fatal "${FUNCNAME[0]} usage error"
    local new_cmd=
    for trap_add_name in "$@"; do
        # Grab the currently defined trap commands for this trap
        local existing_cmd=
        existing_cmd="$(trap -p "${trap_add_name}" | awk -F"'" '{print $2}')"

        # Define default command
        # shellcheck disable=SC2015
        [[ "${existing_cmd}" == '' ]] && existing_cmd=':' || :

        # Generate the new command
        new_cmd="${existing_cmd};${trap_add_cmd}"

        # Assign the test
        # shellcheck disable=SC2064
         trap "${new_cmd}" "${trap_add_name}" || \
              fatal "unable to add to trap ${trap_add_name}"
    done
}

# set the trace attribute for the above function.  this is
# required to modify DEBUG or RETURN traps because functions don't
# inherit them unless the trace attribute is set
declare -f -t trap_add
