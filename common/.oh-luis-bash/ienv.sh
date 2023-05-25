#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

# set $TERM variable if not set
if [ -z ${TERM+x} ]; then
    export TERM=xterm
fi
