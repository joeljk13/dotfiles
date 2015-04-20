SHELL = /bin/sh
.SUFFIXES:

DEF_TARGETS = dot-vim vim-plugins dot-bash dot-zsh dot-lynx dot-tmux dot-git \
	dot-profile dot-i3 make

OTHER_TARGETS = all backup-all backup system

VIM_PLUGIN_PATH = ~/.vim-plugins/
DOTFILES_PATH = ~/.dotfiles
HOME_PATH = ~

.PHONY: $(DEF_TARGETS) $(OTHER_TARGETS)

all: $(DEF_TARGETS)

dot-vim:
	cp $(DOTFILES_PATH)/.vimrc $(HOME_PATH)

vim-plugins:
	$(DOTFILES_PATH)/update-vim-plugins $(VIM_PLUGIN_PATH)

dot-bash:
	cp $(DOTFILES_PATH)/.bash* $(HOME_PATH)

dot-zsh:
	cp $(DOTFILES_PATH)/.zsh* $(HOME_PATH)

dot-lynx:
	cp $(DOTFILES_PATH)/.lynxrc $(HOME_PATH)

dot-tmux:
	cp $(DOTFILES_PATH)/.tmux.conf $(HOME_PATH)

dot-git:
	cp $(DOTFILES_PATH)/.gitconfig $(DOTFILES_PATH)/.gitignore $(HOME_PATH)

dot-profile:
	cp $(DOTFILES_PATH)/.*profile $(HOME_PATH)

dot-i3:
	cp -r $(DOTFILES_PATH)/.i3 ~/.i3

csc:
	# Use cycle2 because that's the one I've found to be least crowded
	scp -r $(DOTFILES_PATH)/.tmux.conf $(DOTFILES_PATH)/.vim* \
		$(DOTFILES_PATH)/.gitconfig $(DOTFILES_PATH)/.gitignore \
		$(DOTFILES_PATH)/.bash* $(DOTFILES_PATH)/.zsh* \
		$(DOTFILES_PATH)/.*profile $(DOTFILES_PATH)/.lynxrc \
		$(DOTFILES_PATH)/update-vim-plugins jkottas@cycle2.csug.rochester.edu:~
	scp -r $(VIM_PLUGIN_PATH) jkottas@cycle2.csug.rochester.edu:~/
	# Don't have the .git directories taking up space
	ssh jkottas@cycle2.csug.rochester.edu \
		'find $(VIM_PLUGIN_PATH) -name .git -type d -exec rm -rf "{}" +; \
		./update-vim-plugins $(VIM_PLUGIN_PATH)'

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
