SHELL = /bin/sh
.SUFFIXES:

DEF_TARGETS = dot-vim vim-plugins dot-bash dot-zsh dot-lynx dot-tmux dot-git \
	dot-profile dot-shell dot-i3 make

OTHER_TARGETS = all

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

dot-shell:
	cp $(DOTFILES_PATH)/.shellrc $(HOME_PATH)

dot-i3:
	cp -r $(DOTFILES_PATH)/.i3 ~/.i3

make:
	cp $(DOTFILES_PATH)/Makefile $(HOME_PATH)
