#!/usr/bin/env bash

#xsetroot -solid "#63656c" -cursor_name left_ptr
#xscreensaver &
#exec xmonad
#exec dwm
#export XDG_RUNTIME_DIR=/u/clehner

# Disable DPMS turning off the screen
xset -dpms
xset s off

# Disable bell
xset -b

# Use XToolkit in java applications
#export AWT_TOOLKIT=XToolkit

# Enable core dumps in case something goes wrong
#ulimit -c unlimited

# Enable zapping (C-A-<Bksp> kills X)
setxkbmap -option terminate:ctrl_alt_bksp

#echo "Starting at $(date)" >> ~/.i3/logfile
. ~/.bashrc
#exec /u/clehner/usr/bin/i3 -V -d all &>> ~/.i3/logfile

#xmodmap ~/.xmodmap
#xrdb ~/.Xresources

export TERMINAL=xterm
exec i3
