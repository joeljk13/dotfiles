# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

. ~/.profile

case $- in
    (*i*) ;;
    (*) return ;;
esac

# Don't put duplicate commands in history
HISTCONTROL=ignoredups

# Append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1024
HISTFILESIZE=2048

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Enable ** when globbing
shopt -s globstar

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] » '
# For a non-color prompt
# PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Enable tab completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Not sure that I'm supposed to do this, but it works
if hash __git_complete 2>/dev/null; then
    __git_complete g __git_main
fi

source ~/.shellrc

alias ez='exec zsh'
