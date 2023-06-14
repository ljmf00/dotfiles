#!/usr/bin/env bash

unset ID

if [ -f /etc/os-release ]; then
    . /etc/os-release
fi

if [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
fi

if [ -n "${DISTRIB_ID+x}" ]; then
    DISTRIB_IGNORE=0
elif [ -n "${ID+x}" ]; then
    case "$ID" in
        arch   ) DISTRIB_ID=Arch      ;;
        ubuntu ) DISTRIB_ID=Ubuntu    ;;
        *      ) DISTRIB_ID="${ID,,}" ;;
    esac
    DISTRIB_IGNORE=0
else
    DISTRIB_IGNORE=1
fi

if [ -z "${_installpkgs_system_pkgs_list+x}" ]; then
    declare -a _installpkgs_system_pkgs_list
fi

function _installpkgs_system_check()
{
    # shellcheck disable=SC2015
    [ "$DISTRIB_IGNORE" -eq 1 ] && return || :

    if [ "$1" != "autodetect" ] && [ "$1" != "$DISTRIB_ID" ]; then
        return
    fi

    case "$DISTRIB_ID" in
        Arch)
            if ! \hash pacman 2>/dev/null; then return; fi

            # shellcheck disable=SC2207
            local list_pkgs=( $(pacman -Qgq "$2" 2>/dev/null || echo "$2") )

            for pkg in "${list_pkgs[@]}"; do
                if ! pacman -Qq "$pkg" >/dev/null 2>&1; then
                    _installpkgs_system_pkgs_list+=("$pkg")
                fi
            done
            ;;
        *)
            echo "Distro '$DISTRIB_ID' not yet supported" >&2
            return 1
            ;;
    esac
}

function installpkgs_system_install()
{
    if [ "${_installpkgs_system_pkgs_list:-}" != "" ]; then
        case "$DISTRIB_ID" in
            Arch)
                pkexec pacman -S --needed --noconfirm "${_installpkgs_system_pkgs_list[@]}"
                ;;
            *)
                echo "Distro '$DISTRIB_ID' not yet supported" >&2
                return 1
                ;;
        esac
    fi
}

function installpkgs_appfile()
{
    while read -r pkg_line; do
        local pkg_linecmd=
        local pkg_lineargs=()

        pkg_linecmd="$(cut -f1 -d' ' <<<"$pkg_line")"
        read -ra pkg_lineargs < <(echo "$pkg_line" | cut -f1 -d' ' --complement)

        case "$pkg_linecmd" in
            flatpak-app )
                if ! \hash flatpak 2>/dev/null; then continue; fi

                if ! flatpak info --arch="$(uname -m)" -r "${pkg_lineargs[${#pkg_lineargs[@]} - 1]}" >/dev/null 2>&1; then
                    pkexec flatpak install --app --assumeyes --noninteractive --arch="$(uname -m)" "${pkg_lineargs[@]}"
                fi
                ;;
            flatpak-runtime )
                if ! \hash flatpak 2>/dev/null; then continue; fi

                if ! flatpak info --arch="$(uname -m)" -r "${pkg_lineargs[${#pkg_lineargs[@]} - 1]}" >/dev/null 2>&1; then
                    pkexec flatpak install --runtime --assumeyes --noninteractive --arch="$(uname -m)" "${pkg_lineargs[@]}"
                fi
                ;;
            flatpak-remote )
                if ! \hash flatpak 2>/dev/null; then continue; fi

                pkexec flatpak remote-add --if-not-exists "${pkg_lineargs[@]}"
                ;;
            sys-package )
                _installpkgs_system_check autodetect "${pkg_lineargs[@]}"
                ;;
            sys-package-ubuntu )
                _installpkgs_system_check Ubuntu "${pkg_lineargs[@]}"
                ;;
            sys-package-archlinux )
                _installpkgs_system_check Arch "${pkg_lineargs[@]}"
                ;;
            '') ;;
            *)
                echo "App command '$pkg_linecmd' not supported, ignoring" >&2
                ;;
        esac
    done < "$1"
}
