#!/usr/bin/env bash

exec_micro_cmd() {
	if hash micro 2>/dev/null; then
		micro $@
	else
		"$HOME/.local/bin/micro" $@
	fi
}

echo "Update micro text editor plugins..."
exec_micro_cmd -plugin update

echo "Install micro text editor plugins..."
exec_micro_cmd -plugin install misspell
exec_micro_cmd -plugin install editorconfig
exec_micro_cmd -plugin install comment
exec_micro_cmd -plugin install filemanager
exec_micro_cmd -plugin install manipulator
