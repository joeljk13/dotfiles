SHELL = /bin/sh
.SUFFIXES:

DEF_TARGETS = dot-vim vim-plugins dot-bash dot-lynx dot-tmux dot-git dot-mutt \
	dot-pal dot-task dot-net dot-profile make

OTHER_TARGETS = all backup-all backup system

DOTFILES_PATH = ~/Joel/programming/dotfiles
HOME_PATH = ~

.PHONY: $(DEF_TARGETS) $(OTHER_TARGETS)

all: $(DEF_TARGETS)

dot-vim:
	cp $(DOTFILES_PATH)/.vimrc $(HOME_PATH)
	cp -r $(DOTFILES_PATH)/.vim $(HOME_PATH)

vim-plugins:
	$(DOTFILES_PATH)/update-vim-plugins

dot-bash:
	cp $(DOTFILES_PATH)/.bash* $(HOME_PATH)

dot-lynx:
	cp $(DOTFILES_PATH)/.lynxrc $(HOME_PATH)

dot-tmux:
	cp $(DOTFILES_PATH)/.tmux.conf $(HOME_PATH)

dot-git:
	cp $(DOTFILES_PATH)/.gitconfig $(HOME_PATH)
	cp $(DOTFILES_PATH)/.gitignore $(HOME_PATH)

dot-mutt:
	cp $(DOTFILES_PATH)/.muttrc $(HOME_PATH)

dot-pal:
	cp -r $(DOTFILES_PATH)/.pal $(HOME_PATH)

dot-task:
	cp -r $(DOTFILES_PATH)/.task $(HOME_PATH)
	cp $(DOTFILES_PATH)/.taskrc $(HOME_PATH)

dot-net:
	cp $(DOTFILES_PATH)/.netrc $(HOME_PATH)

dot-profile:
	cp $(DOTFILES_PATH)/.profile $(HOME_PATH)

make:
	cp $(DOTFILES_PATH)/Makefile $(HOME_PATH)

backup-all: backup
	zip -9 -r VIM.zip ~/Joel/ -x=~/Joel/software*
	sendbeast VIM.zip
	rm VIM.zip
	zip -9 ~/Joel/software.zip ~/Joel/software/*
	sendbeast ~/Joel/software.zip
	rm ~/Joel/software.zip

backup:
	zip -9 -r VIMmin.zip ~/Joel/programming/ -x=~/Joel/programming/libs* \
		-x=~/Joel/programming/c++/fltk*
	sendbeast VIMmin.zip
	rm VIMmin.zip

system:
	sudo apt-get update
	sudo apt-get dist-upgrade
	sudo apt-get autoremove
