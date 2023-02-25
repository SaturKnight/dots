#!/bin/sh

xrdb merge ~/.Xresources 
xbacklight -set 100 &
feh --bg-center ~/Pictures/wall/current.png &
xset r rate 200 50 &

~/.config/chadwm/scripts/bar.sh &
while type dwm >/dev/null; do dwm && continue || break; done
