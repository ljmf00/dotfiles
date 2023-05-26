#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

# Add .local/bin/ to PATH
export PATH="$HOME/.local/bin:$PATH"

# ccache configurations
export USE_CCACHE=1
export CCACHE_COMPRESS=1

# Wine
export WINEPREFIX=$HOME/.wine
export WINEARCH=win64

# Java
if hash archlinux-java 2>/dev/null; then
    JAVA_HOME="/usr/lib/jvm/$(archlinux-java get)/"
else
    JAVA_HOME="/usr/lib/jvm/default/"
fi
export JAVA_HOME

# Python
if ! hash pyenv 2>/dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
fi

if hash pyenv 2>/dev/null; then
    eval "$(pyenv init -)"
fi

# Android
export ANDROID_HOME=/opt/android-sdk

# jBOSS
export JBOSS_HOME=/opt/wildfly

# set $USER variable
if [ -z ${USER+x} ]; then
    export USER
    USER="$(id -u -n)"
fi

export EDITOR="$HOME/.local/bin/editor"
export VISUAL="$HOME/.local/bin/editor"
