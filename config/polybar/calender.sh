BAR_HEIGHT=32  # polybar height
BORDER_SIZE=1  # border size from your wm settings
YAD_WIDTH=320  # popup width
YAD_HEIGHT=280 # popup height
DATE="$(LC_TIME=en_US.UTF-8 date +"%A, %d %b at %H:%M")"

case "$1" in
--popup)
    if [ "$(xdotool getwindowfocus getwindowname)" = "yad-calendar" ]; then
        exit 0
    fi

    eval "$(xdotool getmouselocation --shell)"
    eval "$(xdotool getdisplaygeometry --shell)"

    # X
    if [ "$((X + YAD_WIDTH / 2 + BORDER_SIZE))" -gt "$WIDTH" ]; then #Right side
        : $((pos_x = WIDTH - YAD_WIDTH - BORDER_SIZE))
    elif [ "$((X - YAD_WIDTH / 2 - BORDER_SIZE))" -lt 0 ]; then #Left side
        : $((pos_x = BORDER_SIZE))
    else #Center
        : $((pos_x = X - YAD_WIDTH / 2))
    fi

    # Y
    if [ "$Y" -gt "$((HEIGHT / 2))" ]; then #Bottom
        : $((pos_y = HEIGHT - YAD_HEIGHT - BAR_HEIGHT - BORDER_SIZE))
    else #Top
        : $((pos_y = BAR_HEIGHT + BORDER_SIZE))
    fi

    yad --calendar --undecorated --fixed --close-on-unfocus --no-buttons \
        --width="$YAD_WIDTH" --height="$YAD_HEIGHT" --posx="$pos_x" --posy="$pos_y" \
        --title="yad-calendar" --borders=0 \
        --css="$HOME/.config/polybar/calendar.css" >/dev/null &
    ;;
*)
    echo "$DATE"
    ;;
esac
