#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

# Bash completion
# shellcheck disable=SC1091
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# pkgfile hook
if [ -f "/usr/share/doc/pkgfile/command-not-found.bash" ]; then
	# shellcheck disable=SC1091
	source /usr/share/doc/pkgfile/command-not-found.bash
fi
