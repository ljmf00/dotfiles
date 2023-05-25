#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

# GPG
GPG_TTY="$(tty)"
export GPG_TTY

if hash gpgconf 2> /dev/null; then
	if ! pgrep -u "$USER" gpg-agent > /dev/null; then
		gpgconf --launch gpg-agent
	fi

	if ! pgrep -u "$USER" dirmngr > /dev/null; then
		gpgconf --launch dirmngr
	fi

    if [[ -z ${SSH_AUTH_SOCK+x} && -f "$HOME/.gnupg/sshcontrol" ]]; then
        export SSH_AGENT_PID=
        SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
        export SSH_AUTH_SOCK
    fi
fi
