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
DOTFILES_FOLDER="$(dirname $DOTFILES_FOLDER)"
unset SOURCE

echo "Apply common dotfiles..."
rsync -avh --progress "$DOTFILES_FOLDER/common/" "$HOME/"

IFS=$'\n'
for folder in $(find "$DOTFILES_FOLDER/" -maxdepth 1 -mindepth 1 -type d -iname 'machine_*'); do
	MACHINE="$(basename "$folder" | sed 's/machine_\(.*$\)/\1/')"

	if [ "$(cat /etc/hostname)" == "$MACHINE" ]; then
		echo "Apply machine '$MACHINE' dotfiles..."
		rsync -avh --progress "$folder/" "$HOME/"
	else
		echo "Skip machine '$MACHINE'"
	fi
done
