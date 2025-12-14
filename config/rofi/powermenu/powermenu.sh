#!/bin/bash

# Current Theme
dir="$HOME/.config/rofi/powermenu"
theme='style'

# CMDs
uptime="$(uptime -p | sed -e 's/up //g')"
host=$(hostname)

# Options
lvdund=" Info"
shutdown=" Shutdown"
reboot=" Reboot"
lock=" Lock"
suspend="󰏥 Suspend"
logout="󰗽 Logout"
yes=' Yes'
no=' No'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "Uptime: $uptime" \
		-mesg "Uptime: $uptime" \
		-theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${dir}/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lvdund\n$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		case $1 in
		--shutdown) systemctl poweroff ;;
		--reboot) systemctl reboot ;;
		--suspend)
			playerctl pause # Pause any MPRIS-compliant media player
			# pactl set-sink-mute @DEFAULT_SINK@ 1   # Mute via Pulse/ PipeWire
			systemctl suspend
			;;
		--logout)
			i3-msg exit
			;;
		esac
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case "$chosen" in
*Info)
	rofi -e "User: $USER | Host: $host | Uptime: $uptime"
	;;
*Shutdown)
	run_cmd --shutdown
	;;
*Reboot)
	run_cmd --reboot
	;;
*Lock)
	playerctl pause # Pause any MPRIS-compliant media player
	i3lock -c 000000
	;;
*Suspend)
	run_cmd --suspend
	;;
*Logout)
	run_cmd --logout
	;;
esac
