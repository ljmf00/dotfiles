#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

#
# Common to ~/.bashrc files
#

# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/env.sh"

# If not running interactively, don't do anything!
[[ $- != *i* ]] && return

# Load shell integration script before safe failures as we don't control it.

# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/term.sh"

# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/functions.sh"

# block user input
stty -echo

# set safe failures
set -euo pipefail

# trap to interactively exit on failed startup
trap _bashrc_akey_continue EXIT

# sanity check for bash 4+
(( BASH_VERSINFO[0] < 4 )) && echo "Bash 4+ required." && exit 1

# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/ienv.sh"
# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/gpg.sh"
# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/alias.sh"
# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/shopt.sh"
# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/binds.sh"
# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/complete.sh"
# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/colors.sh"
# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/goto-command.sh"

# reenable input
stty echo

# reenable bash failures
set +euo pipefail

# untrap exit
trap - EXIT

# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/prompt.sh"
