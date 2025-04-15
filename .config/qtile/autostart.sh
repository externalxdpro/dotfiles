#!/usr/bin/env sh

$HOME/.screenlayout.sh &    # for x11
kanshi &                    # for wayland
nitrogen --restore &
/usr/bin/lxpolkit &
dunst -conf $HOME/.config/dunst/qtilerc &
picom &
/usr/bin/emacs --daemon &
numlockx on &
nm-applet --indicator &
blueman-applet &
udiskie &
dex -a -s .config/autostart &

