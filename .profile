#!/bin/sh

export PATH="$HOME/bin:$HOME/usr/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$HOME/.git-scripts:$HOME/.cabal/bin:$HOME/.gem/bin"
export EDITOR=vim
export LANG=en_US.UTF-8
export LD_LIBRARY_PATH="$HOME/lib"
export TERM=screen-256color
export PAGER=less
export LESS=-XFR
export MANPATH="$HOME/usr/share/man:/usr/man:/usr/share/man:/usr/local/share/man"

_PROFILE_HOME="$(readlink -f "$HOME")" && HOME="$_PROFILE_HOME" || \
    _PROFILE_HOME="$HOME"
if [ "$(readlink -f "$(pwd)")" = "$HOME" ]
then
    cd "$HOME"
fi
