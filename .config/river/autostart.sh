#!/usr/bin/env sh

kanshi -c ~/.config/kanshi/riverconf &
swayidle -w timeout 300 'swaylock -f' timeout 360 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' &
sway-audio-idle-inhibit &
waybar -c ~/.config/waybar-river/config -s ~/.config/waybar-river/style.css &
swww-daemon &
$HOME/.local/bin/swww-random &
lxpolkit &
dunst -conf $HOME/.config/dunst/riverrc &
emacs --daemon &
nm-applet &
blueman-applet &
udiskie &
dex -a -s .config/autostart &
mpd & mpDris2 & mpd-discord-rpc &
