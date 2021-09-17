#!/usr/bin/env bash

USER_PERM="${1:-$(whoami)}"
USER_HOME="$(eval echo "~$USER_PERM")"
GROUP_PERM="${2:-$(id -gn)}"

# dont run chown for root user or group
if [[ "$USER_PERM" == "root" || "$GROUP_PERM" == "root" ]]; then
	echo -e "Can't fix permissions for 'root'. Please execute like this, instead:\n"
	echo -e " sudo $0 \$(whoami) \$(id -gn)\n"
	exit 1
fi

fix_file_permission() {
	local chown_aargs=''

	if [[ "$3" == "1" ]]; then
			chown_aargs+="-R"
	fi

	if [[ -f "$1" || -d "$1" ]]; then
		chown -v $chown_aargs "${USER_PERM}:${GROUP_PERM}" "$1"
		chmod -v $chown_aargs "$2" "$1"
	else
		echo "Skip '$1'"
	fi
}

# SSH
fix_file_permission "$USER_HOME/.ssh/" 0700
fix_file_permission "$USER_HOME/.ssh/id_rsa" 0600
fix_file_permission "$USER_HOME/.ssh/id_rsa.pub" 0644
fix_file_permission "$USER_HOME/.ssh/id_rsa_codacy" 0600
fix_file_permission "$USER_HOME/.ssh/id_rsa_codacy.pub" 0644

# GPG
fix_file_permission "$USER_HOME/.gnupg/" 0700
fix_file_permission "$USER_HOME/.gnupg/gpg.conf" 0600

# Bash and ZSH
fix_file_permission "$USER_HOME/.bashrc" 0755
fix_file_permission "$USER_HOME/.bash_history" 0600
fix_file_permission "$USER_HOME/.zshrc" 0755
fix_file_permission "$USER_HOME/.zsh_history" 0600

# Make scripts executable
fix_file_permission "$USER_HOME/scripts" 0755 1
