SHELL = /bin/sh
.SUFFIXES:

.PHONY: all
all: ~/.vimrc ~/.bashrc ~/.bash_profile ~/.zshrc ~/.shellrc ~/.zprofile \
	~/.profile ~/.lynxrc ~/.tmux.conf ~/.gitconfig ~/.gitignore ~/.i3/config \
	~/.xinitrc ~/Makefile vim-plugins zsh-plugins vim-dirs bin-dirs

~/.vim-plugins/update: ~/.dotfiles/update-vim-plugins
	cp "$<" "$@"

~/.zsh-plugins/update: ~/.dotfiles/update-zsh-plugins
	cp "$<" "$@"

.PHONY: vim-plugins
vim-plugins: ~/.vim-plugins/update
	~/.vim-plugins/update

.PHONY: zsh-plugins
zsh-plugins: ~/.zsh-plugins/update
	~/.zsh-plugins/update

.PHONY: vim-dirs
vim-dirs:
	mkdir -p ~/.vim/backup

.PHONY: bin-dirs
bin-dirs:
	mkdir -p ~/bin
	mkdir -p ~/usr/bin
	mkdir -p ~/.gem/bin
	mkdir -p ~/lib

# To update tmux plugins, do PREFIX + U

~/.vimrc: ~/.dotfiles/.vimrc
	cp "$<" "$@"

~/.bashrc: ~/.dotfiles/.bashrc
	cp "$<" "$@"

~/.bash_profile: ~/.dotfiles/.bash_profile
	cp "$<" "$@"

~/.zshrc: ~/.dotfiles/.zshrc
	cp "$<" "$@"

~/.shellrc: ~/.dotfiles/.shellrc
	cp "$<" "$@"

~/.zprofile: ~/.dotfiles/.zprofile
	cp "$<" "$@"

~/.profile: ~/.dotfiles/.profile
	cp "$<" "$@"

~/.lynxrc: ~/.dotfiles/.lynxrc
	cp "$<" "$@"

~/.tmux.conf: ~/.dotfiles/.tmux.conf
	cp "$<" "$@"

~/.gitconfig: ~/.dotfiles/.gitconfig
	cp "$<" "$@"

~/.gitignore: ~/.dotfiles/.gitignore
	cp "$<" "$@"

~/.i3/config: ~/.dotfiles/.i3/config
	mkdir -p ~/.i3
	cp "$<" "$@"

~/.xinitrc: ~/.dotfiles/.xinitrc
	cp "$<" "$@"

~/Makefile: ~/.dotfiles/Makefile
	cp "$<" "$@"
