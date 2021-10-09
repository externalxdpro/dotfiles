#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

#Set your native resolution IF it does not exist in xrandr
#More info in the script
#run $HOME/.xmonad/scripts/set-screen-resolution-in-virtualbox.sh

#Find out your monitor name with xrandr or arandr (save and you get this line)
#xrandr --output VGA-1 --primary --mode 1360x768 --pos 0x0 --rotate normal
#xrandr --output DP2 --primary --mode 1920x1080 --rate 60.00 --output LVDS1 --off &
#xrandr --output LVDS1 --mode 1366x768 --output DP3 --mode 1920x1080 --right-of LVDS1
#xrandr --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off
#xrandr --output Virtual1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output Virtual2 --off --output Virtual3 --off --output Virtual4 --off --output Virtual5 --off --output Virtual6 --off --output Virtual7 --off --output Virtual8 --off
xrandr --output eDP1 --mode 1920x1080 --pos 0x700 --rotate normal --output DP1 --primary --mode 1920x1080 --pos 1920x0 --rotate normal

#(sleep 2; run $HOME/.config/polybar/launch.sh) &

#change your keyboard if you need it
#setxkbmap -layout be

#cursor active at boot
xsetroot -cursor_name left_ptr &

#start ArcoLinux Welcome App
run dex $HOME/.config/autostart/arcolinux-welcome-app.desktop

#Some ways to set your wallpaper
#feh --bg-fill /usr/share/backgrounds/arcolinux/arco-wallpaper.jpg &
nitrogen --restore &

#starting utility applications at boot time
xrandr --output eDP1 --mode 1920x1080 --pos 0x700 --rotate normal --output DP1 --primary --mode 1920x1080 --pos 1920x0 --rotate normal
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
picom --config $HOME/.xmonad/scripts/picom.conf &
nm-applet &
pamac-tray &
volumeicon &
numlockx on &
blueberry-tray &
polychromatic-tray-applet &
/usr/bin/trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282c34  --height 22 &
/usr/bin/emacs --daemon & #emacs daemon for the emacsclient

#uncomment to restore last saved wallpaper
#xargs xwallpaper --stretch < ~/.xwallpaper

#~/.fehbg &  #set last saved feh wallpaper
#feh --randomize --bg-fill ~/wallpapers/*  #feh set random wallpaper
nitrogen --restore &   #if you prefer nitrogen to feh

#start the conky to learn the shortcuts
#(conky -c $HOME/.xmonad/scripts/system-overview) &

#starting user applications at boot time
rclone --vfs-cache-mode writes mount onedrive-home: $HOME/onedrive/ &
#run caffeine &
#run vivaldi-stable &
#run firefox &
#run thunar &
#run spotify &
#run atom &

#run telegram-desktop &
run discord &
run obsidian &
run steam &
#run dropbox &
#run insync start &
#run ckb-next -b &
