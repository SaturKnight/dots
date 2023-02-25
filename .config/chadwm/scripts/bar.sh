#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/galerion

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$black^ ^b$yellow^ CPU"
  printf "^c$white^ ^b$grey^ $cpu_val"
}

pkg_updates() {
  updates=$(xbps-install -un | wc -l) # void
  #updates=$(checkupdates 2>/dev/null | wc -l) # arch
  # updates=$(aptitude search '~U' | wc -l)  # apt (ubuntu,debian etc)

  if [ "$updates" -eq "0" ]; then
    printf "  ^c$green^   󰬬 Fully Updated"
  else
    printf "  ^c$yellow^   󰬦 $updates"" updates"
  fi
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
  printf "^c$blue^ 󰁹  $get_capacity"
}

volume() {
  printf "^c$red^ 󰕾  "
  printf "^c$red^%.0f\n" $(amixer sget Master | grep 'Mono:' | awk -F'[][]' '{ print $2 }')
}

mem() {
  printf "^c$yellow^^b$black^ 󰘚 "
  printf "^c$yellow^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$darkblue^ 󰥔 "
	printf "^c$black^^b$blue^ $(date '+%A, %d %B %Y | %H:%M')  "
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name " $updates $(battery)% $(volume)% $(cpu) $(mem) $(wlan) $(clock)"
done
