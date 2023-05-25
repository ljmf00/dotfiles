#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

if hash starship 2>/dev/null; then
    eval "$(starship init bash)"

    starship_precmd_user_func="_bashrc_set_windowtitle"
fi
