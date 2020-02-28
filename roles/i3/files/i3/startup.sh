#!/bin/sh

xset r rate 300 35

setxkbmap -option caps:escape

~/.config/i3/wp-changer.sh &
~/Downloads/activitywatch/aw-qt &

xrdb ~/.Xresources

if ! urxvtc "$@"; then
  urxvtd -q -o -f
fi

tmux new-session -d -s def
tmuxinator start dotfiles --no-attach

sleep 1; autorandr --change

joplin-gui &

blueman-applet &

sleep 5; dropbox start -i

fluxgui &
