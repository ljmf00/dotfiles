#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

#
# ~/.bash_logout
#

# If not running interactively, don't do anything!
[[ $- != *i* ]] && return

# on an ssh session dont do nothing
[[ -n ${SSH_CLIENT+x} || -n ${SSH_TTY+x} ]] && return || :

clear
reset
