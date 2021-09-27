all: configure

configure:
	./configure.sh

apply:
	./scripts/apply-dotfiles.shp

cfg-vscode:
	./scripts/configure-vscode.sh

cfg-bash:
	./scripts/configure-bash.sh

upd-gpg:
	./scripts/update-gpg.sh
