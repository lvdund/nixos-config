DIRECTION=$1   # left | right
WS_DIRECTION=$2  # prev | next

# Single call: extract everything we need from workspaces list
read -r CURRENT_WS MIN_WS MAX_WS < <(i3-msg -t get_workspaces | jq -r '
    (map(.num) | min) as $min |
    (map(.num) | max) as $max |
    (.[] | select(.focused == true).num) as $cur |
    "\($cur) \($min) \($max)"
')

# Single call: extract focused window x and all window x positions on current workspace
read -r FOCUSED_X LEFTMOST_X RIGHTMOST_X < <(i3-msg -t get_tree | jq -r --argjson ws "$CURRENT_WS" '
    (.. | select(.focused? == true) | select(.window? != null) | .rect.x) as $fx |
    (.. | select(.type? == "workspace" and .num? == $ws) |
        [ .. | select(.window? != null) | .rect.x ] | sort) as $xs |
    "\($fx) \($xs | first) \($xs | last)"
')

if [ -z "$FOCUSED_X" ]; then
    # Empty workspace — attempt workspace switch directly
    [ "$WS_DIRECTION" == "prev" ] && [ "$CURRENT_WS" -gt "$MIN_WS" ] && i3-msg workspace prev
    [ "$WS_DIRECTION" == "next" ] && [ "$CURRENT_WS" -lt "$MAX_WS" ] && i3-msg workspace next
    exit 0
fi

if [ "$DIRECTION" == "left" ]; then
    if [ "$FOCUSED_X" -le "$LEFTMOST_X" ]; then
        [ "$CURRENT_WS" -gt "$MIN_WS" ] && i3-msg workspace prev
    else
        i3-msg focus left
    fi
elif [ "$DIRECTION" == "right" ]; then
    if [ "$FOCUSED_X" -ge "$RIGHTMOST_X" ]; then
        [ "$CURRENT_WS" -lt "$MAX_WS" ] && i3-msg workspace next
    else
        i3-msg focus right
    fi
fi
