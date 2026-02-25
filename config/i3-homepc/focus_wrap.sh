DIRECTION=$1
WS_DIRECTION=$2

BEFORE_X=$(i3-msg -t get_tree | jq '.. | select(.focused? == true).rect.x')

CURRENT_WS=$(i3-msg -t get_workspaces | jq '.[] | select(.focused == true).num')
ALL_WS=$(i3-msg -t get_workspaces | jq '[.[].num] | sort')
MIN_WS=$(echo "$ALL_WS" | jq 'min')
MAX_WS=$(echo "$ALL_WS" | jq 'max')

i3-msg focus $DIRECTION > /dev/null

AFTER_X=$(i3-msg -t get_tree | jq '.. | select(.focused? == true).rect.x')

IF_WRAP=false

if [ "$BEFORE_X" == "$AFTER_X" ]; then
    IF_WRAP=true
elif [ "$DIRECTION" == "left" ] && [ "$AFTER_X" -gt "$BEFORE_X" ]; then
    IF_WRAP=true
elif [ "$DIRECTION" == "right" ] && [ "$AFTER_X" -lt "$BEFORE_X" ]; then
    IF_WRAP=true
fi

if [ "$IF_WRAP" = true ]; then
    if [ "$WS_DIRECTION" == "prev" ] && [ "$CURRENT_WS" -gt "$MIN_WS" ]; then
        i3-msg workspace $WS_DIRECTION
    elif [ "$WS_DIRECTION" == "next" ] && [ "$CURRENT_WS" -lt "$MAX_WS" ]; then
        i3-msg workspace $WS_DIRECTION
    fi
fi
