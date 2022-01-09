#!/usr/bin/env bash

# set safe failures
set -euxo pipefail

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

#shellcheck disable=SC2031
(source "$DOTFILES_FOLDER/scripts/apply-dotfiles.sh")
#shellcheck disable=SC2031
# source "$DOTFILES_FOLDER/scripts/get-micro.sh"
#shellcheck disable=SC2031
# source "$DOTFILES_FOLDER/scripts/configure-micro.sh"
#shellcheck disable=SC2031
(source "$DOTFILES_FOLDER/scripts/configure-bash.sh")
#shellcheck disable=SC2031
(source "$DOTFILES_FOLDER/scripts/configure-qutebrowser.sh")
#shellcheck disable=SC2031
# source "$DOTFILES_FOLDER/scripts/configure-vscode.sh"
#shellcheck disable=SC2031
(source "$DOTFILES_FOLDER/scripts/fix-permissions.sh")
