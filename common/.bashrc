#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

#
# ~/.bashrc
#

# Add .local/bin/ to PATH
export PATH="$HOME/.local/bin:$PATH"

# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/functions.sh"
# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/alias.sh"
# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/shopt.sh"
# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/binds.sh"
# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/goto-command.sh"
