#!/usr/bin/env bash

compress() {
	tar -czf "${1}.tar.gz" "$1" && rm -rf "$1"
}

extract() {
	tar -xzf "$1" && rm -rf "$1"
}

if [ "$1" != "" ]; then
	if [ -d "$1" ]; then
		compress "$1"
	elif [ -f "$1.tar.gz" ]; then
		extract "$1.tar.gz"
	else
		echo "Not found"
		exit 1
	fi
else
	if [ "$(find . -maxdepth 1 -mindepth 1 -type f)" == "./revert-workspace.sh" ]; then
		find . -maxdepth 1 -mindepth 1 -type d -print0 | while IFS= read -r -d $'\0' folder; do
			compress "$folder"
		done
	else
		find . -maxdepth 1 -mindepth 1 -type f -print0 | while IFS= read -r -d $'\0' file; do
			if [[ "$file" != "./revert-workspace.sh" && "$file" == *".tar.gz" ]]; then
				extract "$file"
			fi
		done
	fi
fi

chown -R luis:sudo .
