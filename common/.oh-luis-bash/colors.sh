#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

# define set_windowtitle and ncolors as early as possible
case "$TERM" in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*|linux*|tmux*)
        ncolors="$(tput colors)"
        ;;
    *)
        ncolors=0
        ;;
esac

if test -n "$ncolors" && test "$ncolors" -ge 8; then
    # add termcap for less when colors are available
    export LESS=-FSR
    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    if hash dircolors 2> /dev/null; then
        eval "$(dircolors -b ~/.oh-luis-bash/.dircolors)"
    fi
fi

# set true color for micro editor
if [ -n "${COLORTERM+x}" ] && [ "$COLORTERM" == "truecolor" ] && hash micro 2> /dev/null; then
    MICRO_TRUECOLOR=1
    export MICRO_TRUECOLOR
fi
