#!/usr/bin/env bash

set -eo pipefail

if ! hash micro 2>/dev/null; then
	mkdir -vp "$HOME/.local/bin/"

	TEMP_DIR_MICRO="$(mktemp -d)"
	set +e +o pipefail
	(
		cd "$TEMP_DIR_MICRO"
		curl https://getmic.ro | bash
		mv -v "micro" "$HOME/.local/bin/"
	)
	set -eo pipefail

	rm -rf "$TEMP_DIR_MICRO"
fi
