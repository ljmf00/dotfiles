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

source "$DOTFILES_FOLDER/scripts/apply-dotfiles.sh"
source "$DOTFILES_FOLDER/scripts/get-micro.sh"
source "$DOTFILES_FOLDER/scripts/configure-micro.sh"
source "$DOTFILES_FOLDER/scripts/configure-bash.sh"
source "$DOTFILES_FOLDER/scripts/configure-vscode.sh"
source "$DOTFILES_FOLDER/scripts/fix-permissions.sh"
