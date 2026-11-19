dms run >/dev/null 2>&1 &
/usr/lib/xdg-desktop-portal-wlr >/dev/null 2>&1 &
awww-daemon >/dev/null 2>&1 &
$HOME/.local/bin/awww-random >/dev/null 2>&1 &
lxpolkit >/dev/null 2>&1 &
emacs --daemon >/dev/null 2>&1 &
udiskie >/dev/null 2>&1 &
dex -a -s "$HOME/.config/autostart" >/dev/null 2>&1 &
