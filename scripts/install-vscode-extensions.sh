#!/usr/bin/env bash

set -eo pipefail

[[ -z "${1+x}" ]] && (echo "Please provide an extension name!"; exit 1)

vscode_api() {
	curl \
		-sS -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246" \
		"https://$PUBLISHER_NAME.gallery.vsassets.io/_apis/public/gallery/publisher/$PUBLISHER_NAME/extension/$EXTENSION_NAME/$EXTENSION_VERSION/assetbyname/$1"
}

vercomp () {
    if [[ "$1" == "$2" ]]; then
        return 0
    fi
    local IFS=.
    # shellcheck disable=SC2206
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 0
        fi
    done
    return 0
}

PUBLISHER_NAME="$(echo "$1" | cut -d. -f1)"
EXTENSION_NAME="$(echo "$1" | cut -d. -f1 --complement | cut -d@ -f1)"

if [[ "$1" == "${PUBLISHER_NAME}.${EXTENSION_NAME}@"* ]]; then
	EXTENSION_VERSION="$(echo "$1" | cut -d@ -f 2)"
else
	EXTENSION_VERSION="latest"
fi

FULL_EXTENSION_NAME="$(echo "$1" | cut -d@ -f1)"

# Get actual extension manifest
echo "Getting extension '$FULL_EXTENSION_NAME' manifest..."
EXTENSION_VERSION="$(vscode_api Microsoft.VisualStudio.Services.VsixManifest | sed -n 's|<Identity .*\Version="\([0-9.]*\)".*\/>|\1|p' | tr -d ' ')"
[ "$EXTENSION_VERSION" == "" ] && (echo "Please provide a valid extension with correct version!"; exit 1)

TEMP_FOLDER="$(mktemp -d /tmp/vscode.XXXXXXXXXX)"

# shellcheck disable=SC2064
trap "rm -rf '$TEMP_FOLDER'" EXIT

run_code_cmd() {
	if hash code 2>/dev/null; then
		code "$@"
	elif hash code-server 2>/dev/null; then
		code-server "$@"
	fi
}

install_vscode_extension() {
	echo "Downloading '$FULL_EXTENSION_NAME' extension..."
	vscode_api Microsoft.VisualStudio.Services.VSIXPackage > "$TEMP_EXTENSION_PATH"

	# shellcheck disable=SC2064
	trap "echo 'ERROR: Cant install $FULL_EXTENSION_NAME extension!'" ERR
	run_code_cmd --install-extension "$TEMP_EXTENSION_PATH" 2> /dev/null | awk "{print \"[$FULL_EXTENSION_NAME] \"\$0}"
}

if hash code 2>/dev/null || hash code-server 2>/dev/null; then
	TEMP_EXTENSION_PATH="$TEMP_FOLDER/${FULL_EXTENSION_NAME}-${EXTENSION_VERSION}.vsix"

	echo "Looking for the extension locally..."
	LOCAL_EXTENSION_BASENAME="$(find "$HOME/.vscode/extensions/" -maxdepth 1 -mindepth 1 -iname "${FULL_EXTENSION_NAME,,}-*" -exec basename {} \; | grep -Po "${FULL_EXTENSION_NAME,,}-(\d+\.)+\d+$" || :)"

	if [ "$LOCAL_EXTENSION_BASENAME" == "" ]; then
		echo "Extension '$FULL_EXTENSION_NAME' not found locally, installing..."
		install_vscode_extension
		exit 0
	fi

	LOCAL_EXTENSION_VERSION="$(echo "$LOCAL_EXTENSION_BASENAME" | sort --version-sort | tail -n1 | grep -Po "(\d+\.)+\d+")"

	if ! vercomp "$EXTENSION_VERSION" "$LOCAL_EXTENSION_VERSION"; then
		echo "Extension '$FULL_EXTENSION_NAME' found and new version '$EXTENSION_VERSION' is available, installing..."
		install_vscode_extension
	else
		echo "Version of '$FULL_EXTENSION_NAME' is up-to-date!"
	fi
else
	echo "Please install visual-studio-code!"
	exit 1
fi

