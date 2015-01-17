SHELL = /bin/sh
.SUFFIXES:

DEF_TARGETS = dot-vim dot-bash dot-lynx dot-tmux dot-git dot-mutt dot-pal \
	dot-task dot-net make

OTHER_TARGETS = all backup system

DOTFILES_PATH = ~/Joel/programming/dotfiles
HOME_PATH = ~

.PHONY: $(DEF_TARGETS) $(OTHER_TARGETS)

all: $(DEF_TARGETS)

dot-vim:
	cp $(DOTFILES_PATH)/.vimrc $(HOME_PATH)
	cp -r $(DOTFILES_PATH)/.vim $(HOME_PATH)

dot-bash:
	cp $(DOTFILES_PATH)/.bash* $(HOME_PATH)

dot-lynx:
	cp $(DOTFILES_PATH)/.lynxrc $(HOME_PATH)

dot-tmux:
	cp $(DOTFILES_PATH)/.tmux.conf $(HOME_PATH)

dot-git:
	cp $(DOTFILES_PATH)/.gitconfig $(HOME_PATH)

dot-mutt:
	cp $(DOTFILES_PATH)/.muttrc $(HOME_PATH)

dot-pal:
	cp -r $(DOTFILES_PATH)/.pal $(HOME_PATH)

dot-task:
	cp -r $(DOTFILES_PATH)/.task $(HOME_PATH)
	cp $(DOTFILES_PATH)/.taskrc $(HOME_PATH)

dot-net:
	cp $(DOTFILES_PATH)/.netrc $(HOME_PATH)

make:
	cp $(DOTFILES_PATH)/Makefile $(HOME_PATH)

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
