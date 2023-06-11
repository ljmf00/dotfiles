#!/usr/bin/env bash

function installpkgs_appfile()
{
    while read -r pkg_line; do
        local pkg_linecmd=
        local pkg_lineargs=()

        pkg_linecmd="$(cut -f1 -d' ' <<<"$pkg_line")"
        read -ra pkg_lineargs < <(echo "$pkg_line" | cut -f1 -d' ' --complement)

        case "$pkg_linecmd" in
            flatpak-app )
                if ! flatpak info --arch="$(uname -m)" -r "${pkg_lineargs[${#pkg_lineargs[@]} - 1]}" >/dev/null 2>&1; then
                    flatpak install --app --assumeyes --noninteractive --arch="$(uname -m)" "${pkg_lineargs[@]}"
                fi
                ;;
            flatpak-remote )
                flatpak remote-add --if-not-exists "${pkg_lineargs[@]}"
                ;;
            *)
                ;;
        esac
    done < "$1"
}
