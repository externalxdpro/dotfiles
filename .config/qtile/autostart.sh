#!/usr/bin/env sh

lxpolkit &
dunst -conf $HOME/.config/dunst/qtilerc &
emacs --daemon &
nm-applet --indicator &
blueman-applet &
udiskie &
dex -a -s .config/autostart &

