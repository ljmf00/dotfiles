#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

if [[ -z ${SSH_AUTH_SOCK+x} ]]; then
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        ssh-agent -t 15m > "$XDG_RUNTIME_DIR/ssh-agent.env"
    fi

    if [ -f "$XDG_RUNTIME_DIR/ssh-agent.env" ]; then
        source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
    else
        eval "$(ssh-agent -t 15m | tee "$XDG_RUNTIME_DIR/ssh-agent.env")"
    fi
fi
