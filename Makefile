all: configure

configure:
	./configure.sh

apply:
	./scripts/apply-dotfiles.shp

vscode:
	./scripts/configure-vscode.sh

