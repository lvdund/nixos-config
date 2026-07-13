#!/usr/bin/env bash

set -eu

read -r CURRENT_WS MIN_WS MAX_WS < <(swaymsg -t get_workspaces -r | jq -r '
  def ws_num:
    gsub("^\\s+|\\s+$"; "")
    | select(test("^[0-9]+$"))
    | tonumber;

  [ .[] | .name | ws_num ] as $ids
  | [(.[] | select(.focused) | .name | ws_num), ($ids | min), ($ids | max)]
  | @tsv
')

read -r FOCUSED_X LEFTMOST_X RIGHTMOST_X < <(swaymsg -t get_tree -r | jq -r --argjson ws "$CURRENT_WS" '
  def ws_num:
    .name
    | gsub("^\\s+|\\s+$"; "")
    | tonumber?;

  first(.. | objects | select(.type? == "workspace" and (ws_num == $ws))) as $workspace
  | [$workspace.nodes[]?, $workspace.floating_nodes[]?]
  | map(select(.focused or .rect?)) as $nodes
  | [
      ($nodes[] | select(.focused) | .rect.x),
      ($nodes | map(.rect.x) | min),
      ($nodes | map(.rect.x) | max)
    ]
  | @tsv
')

DIRECTION="$1"
WS_DIRECTION="$2"

if [ "$FOCUSED_X" = "$LEFTMOST_X" ] && [ "$DIRECTION" = "left" ]; then
    [ "$WS_DIRECTION" = "prev" ] && [ "$CURRENT_WS" -gt "$MIN_WS" ] && swaymsg workspace prev
elif [ "$FOCUSED_X" = "$RIGHTMOST_X" ] && [ "$DIRECTION" = "right" ]; then
    [ "$WS_DIRECTION" = "next" ] && [ "$CURRENT_WS" -lt "$MAX_WS" ] && swaymsg workspace next
else
    if [ "$DIRECTION" = "left" ]; then
        swaymsg focus left
    else
        swaymsg focus right
    fi
fi
