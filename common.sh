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

if ! hash dig 2> /dev/null; then
  echo "!!! Please install bind-tools"
  exit 1
fi

if ! hash git 2> /dev/null; then
  echo "!!! Please install git"
  exit 1
fi

if ! hash xdg-settings 2> /dev/null; then
  echo "!!! Please install xdg-utils"
  exit 1
fi

# check for internet availability
if curl -sf 1.1.1.1 > /dev/null 2>&1; then
  SENDEMAIL_SMTP_SERVER="$(dig +short smtp.lsferreira.net | head -n1 | sed 's/\.[^.]*$//')"

  git config --global sendemail.smtpServer "$SENDEMAIL_SMTP_SERVER"
fi

mkdir -p ~/.ssh/
cp "$DOTFILES_FOLDER/pubkeys/ssh_luis.pub" ~/.ssh/authorized_keys

mkdir -p "$HOME/.weechat/python/"
ln -sf /usr/share/weechat/python/weechat-matrix.py "$HOME/.weechat/python/weechat-matrix.py"
ln -sf ../matrix.py "$HOME/.weechat/python/autoload"
