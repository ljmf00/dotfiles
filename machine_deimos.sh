#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
# resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE" ]; do
  DOTFILES_FOLDER="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  [[ $SOURCE != /* ]] && SOURCE="$DOTFILES_FOLDER/$SOURCE"
done
DOTFILES_FOLDER="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
unset SOURCE

cat >> "$HOME/.ssh/config" << EOF

Host github.com bitbucket.org *.archlinux.org *.onion
    ProxyCommand ncat --proxy-type socks5 --proxy 127.0.0.1:9050 %h %p

Host *.i2p
    ProxyCommand ncat --proxy-type socks5 --proxy 127.0.0.1:4447 %h %p
EOF
