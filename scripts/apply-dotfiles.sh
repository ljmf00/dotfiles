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
DOTFILES_FOLDER="$(dirname "$DOTFILES_FOLDER")"
unset SOURCE

if ! hash rsync 2> /dev/null; then
  echo "!!! Please install rsync"
  exit 1
fi

echo "Apply common dotfiles..."
rsync -avh --progress "$DOTFILES_FOLDER/common/" "$HOME/"

echo "Run common script..."
#shellcheck disable=SC2031
(source "$DOTFILES_FOLDER/common.sh")

#shellcheck disable=SC2031
find "$DOTFILES_FOLDER/" -maxdepth 1 -mindepth 1 -type d -iname 'machine_*' |
  while IFS= read -r folder; do
	MACHINE="$(basename "$folder" | sed 's/machine_\(.*$\)/\1/')"

	if [ "$(cat /etc/hostname)" == "$MACHINE" ]; then
		echo "Apply machine '$MACHINE' dotfiles..."
		rsync -avh --progress "$folder/" "$HOME/"

		#shellcheck disable=SC2031
		if [ -f "$DOTFILES_FOLDER/$(basename "$folder").sh" ]; then
			echo "Run machine $MACHINE script..."
			#shellcheck disable=SC2031
			(source "$DOTFILES_FOLDER/$(basename "$folder").sh")
		fi
	else
		echo "Skip machine '$MACHINE'"
	fi
  done
