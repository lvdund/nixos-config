#!/bin/bash

# Monitor setup script for i3wm
# Place this at ~/.config/i3/monitor-setup.sh
# Make it executable: chmod +x ~/.config/i3/monitor-setup.sh

PRIMARY="eDP-1"
SECONDARY="HDMI-1-1"

# Wait a moment for monitor detection to stabilize
sleep 1

# Check if secondary monitor is connected
if xrandr | grep "$SECONDARY connected" > /dev/null; then
    # Get the preferred resolution for the secondary monitor
    RESOLUTION=$(xrandr | grep -A1 "^$SECONDARY connected" | tail -1 | awk '{print $1}')
    
    if [ -z "$RESOLUTION" ]; then
        # If no resolution found, try common ones
        RESOLUTION="1920x1080"
    fi
    
    echo "Configuring $SECONDARY with resolution $RESOLUTION"
    
    # Enable both monitors
    # Try with explicit mode first, then fallback to auto
    xrandr --output $PRIMARY --mode 1920x1080 --primary --pos 0x0 \
           --output $SECONDARY --mode $RESOLUTION --right-of $PRIMARY 2>/dev/null || \
    xrandr --output $PRIMARY --auto --primary \
           --output $SECONDARY --auto --right-of $PRIMARY
    
    echo "Dual monitor setup enabled: $PRIMARY (primary) + $SECONDARY"
else
    # Only primary monitor - disable secondary
    xrandr --output $PRIMARY --auto --primary \
           --output $SECONDARY --off
    
    echo "Single monitor mode: $PRIMARY only"
fi

# Restore wallpaper on all monitors
sleep 0.5
feh --bg-scale ~/.config/i3/momo_ayase_gruvbox.png

# Notify i3 to refresh
i3-msg restart 2>/dev/null || true
