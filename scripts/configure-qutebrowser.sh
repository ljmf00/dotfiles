#!/usr/bin/env bash

if hash qutebrowser 2>/dev/null; then
  # if [ "$(xdg-settings get default-web-browser)" != "org.qutebrowser.qutebrowser.desktop" ]; then
  #   xdg-settings set default-web-browser org.qutebrowser.qutebrowser.desktop
  # fi

  if [ ! -d "$HOME/.local/share/qutebrowser/qtwebengine_dictionaries/" ]; then
    /usr/share/qutebrowser/scripts/dictcli.py install en-US
    /usr/share/qutebrowser/scripts/dictcli.py install en-GB
    /usr/share/qutebrowser/scripts/dictcli.py install pt-PT
  fi
fi
