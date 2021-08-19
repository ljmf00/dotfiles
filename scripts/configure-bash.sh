#!/usr/bin/env bash

set -eo pipefail

if [ "$EUID" -eq 0 ]; then
	echo "Please dont run as root"
	exit 1
fi

CURRENT_SHELL="$(grep "^$(whoami):" < /etc/passwd | cut -d: -f7)"

if [ "$CURRENT_SHELL" != "/bin/bash" ]; then
	chsh -s /bin/bash "$(whoami)"
else
	echo "User '$(whoami)' already has /bin/bash as default shell."
fi
