#!/usr/bin/env bash

shopt -s lastpipe

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

if [ -z "${DOTFILES_WORKSPACE+x}" ]; then
	WORKSPACE=""

	#shellcheck disable=SC2031,SC2094
	find "$DOTFILES_FOLDER/workspaces/" -maxdepth 1 -mindepth 1 -type f |
	  while IFS= read -r workspace_file; do
		while IFS= read -r machine
		do
			if [ "$(cat /etc/hostname)" == "$machine" ]; then
				#shellcheck disable=SC2094
				WORKSPACE="$(basename "$workspace_file")"
				break 1
			fi
		done < "$workspace_file"
	  done
else
	WORKSPACE="$DOTFILES_WORKSPACE"
fi

if [ "$WORKSPACE" != "" ]; then
	echo "Apply workspace '$WORKSPACE' dotfiles..."
	# FIXME: Bug on shellcheck, fixed in new versions
	#shellcheck disable=SC2031
	rsync -avh --progress "$DOTFILES_FOLDER/workspace_$WORKSPACE/" "$HOME/"

	# FIXME: Bug on shellcheck, fixed in new versions
	#shellcheck disable=SC2031
	if [ -f "$DOTFILES_FOLDER/workspace_$WORKSPACE.sh" ]; then
		echo "Run workspace $WORKSPACE script..."
		#shellcheck disable=SC2031
		(source "$DOTFILES_FOLDER/workspace_$WORKSPACE.sh")
	fi
else
	echo "Required to have a workspace!"
	exit 1
fi


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
