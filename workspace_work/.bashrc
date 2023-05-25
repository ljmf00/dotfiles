#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

#
# ~/.bashrc
#

# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/common.sh"

if [ -f "$HOME/.bashrc-work" ]; then
    source "$HOME/.bashrc-work"
fi
