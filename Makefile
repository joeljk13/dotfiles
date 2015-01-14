SHELL = /bin/sh
.SUFFIXES:

TARGETS = dot-vim dot-bash dot-lynx dot-tmux dot-git dot-mutt dot-pal \
	dot-task dot-net system

.PHONY: all $(TARGETS)

all: $(TARGETS)

dot-vim:
	cp .vimrc ~
	cp -r .vim ~

dot-bash:
	cp .bash* ~

dot-lynx:
	cp .lynxrc ~

dot-tmux:
	cp .tmux.conf ~

dot-git:
	cp .gitconfig ~

dot-mutt:
	cp .muttrc ~

dot-pal:
	cp -r .pal ~

dot-task:
	cp -r .task ~
	cp .taskrc ~

dot-net:
	cp .netrc ~

system:
	sudo apt-get update
	sudo apt-get dist-upgrade
	sudo apt-get autoremove
