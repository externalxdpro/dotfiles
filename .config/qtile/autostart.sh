#!/usr/bin/env sh

kanshi &
/usr/bin/emacs --daemon &
nm-applet &
lxsession &
dex -a -s .config/autostart &
