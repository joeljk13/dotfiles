SHELL = /bin/sh
.SUFFIXES:

TARGETS = dot-vim dot-bash dot-lynx dot-tmux dot-git dot-mutt dot-pal \
	dot-task dot-net make

.PHONY: all $(TARGETS) backup system

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

make:
	cp Makefile ~

backup:
	cp backup Joel/programming/bash/home/
	cp Makefile Joel/programming/bash/home/
	cp .vimrc Joel/programming/vim/vimrc
	cp ~/.vim/colors/joelcolors.vim Joel/programming/vim/
	zip -9 -r VIMmin.zip Joel/programming/ -x=Joel/programming/libs* -x=Joel/programming/c++/fltk*
	sendbeast VIMmin.zip
	# rm VIMmin.zip
	if [ "$1" = "--all" ]
	then
		zip -9 Joel/software.zip Joel/software/*
		zip -9 -r VIM.zip Joel/ -x=Joel/software*
		sendbeast VIM.zip
		# rm VIM.zip
		# rm Joel/software.zip
	fi

system:
	sudo apt-get update
	sudo apt-get dist-upgrade
	sudo apt-get autoremove
