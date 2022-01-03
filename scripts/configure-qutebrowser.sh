#!/usr/bin/env bash

if [ ! -d "$HOME/.local/share/qutebrowser/qtwebengine_dictionaries/" ]; then
  /usr/share/qutebrowser/scripts/dictcli.py install en-US
  /usr/share/qutebrowser/scripts/dictcli.py install en-GB
  /usr/share/qutebrowser/scripts/dictcli.py install pt-PT
fi
