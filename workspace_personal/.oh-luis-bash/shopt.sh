#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

# ===============================
#          BASH OPTIONS
# ===============================

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
#[[ -n ${DISPLAY+x} ]] && shopt -s checkwinsize || :
shopt -s checkwinsize

# Enable history appending instead of overwriting.
shopt -s histappend

# ingore duplicate entries on the history
export HISTCONTROL="ignoredups,ignorespace"

# history size
export HISTSIZE=50000

# Enable autocd, when no cd is provided witha valid path
shopt -s autocd 2> /dev/null
# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null

# Ignored EOF action on interactive shell

# Value of consecutive EOF characters before exiting
export IGNOREEOF=10

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2> /dev/null

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;
