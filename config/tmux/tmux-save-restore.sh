#!/usr/bin/env bash
# =============================================================================
# tmux-save-restore.sh — Save and restore tmux sessions across reboots
#
# Usage:
#   ./tmux-save-restore.sh save [file]
#   ./tmux-save-restore.sh restore [file]
#
# Default save file: ~/.tmux-sessions
# =============================================================================

SAVE_FILE="${2:-$HOME/.tmux-sessions}"

# ── SAVE ─────────────────────────────────────────────────────────────────────
save_sessions() {
    if ! tmux info &>/dev/null; then
        echo "❌  No tmux server running. Nothing to save."
        exit 1
    fi

    : > "$SAVE_FILE"

    tmux list-sessions -F "#{session_name}" 2>/dev/null | while read -r session; do
        tmux list-windows -t "$session" -F "#{window_index} #{window_name}" 2>/dev/null | while read -r win_idx win_name; do
            tmux list-panes -t "${session}:${win_idx}" \
                -F "#{pane_index} #{pane_current_path} #{pane_current_command}" 2>/dev/null \
            | while read -r pane_idx pane_dir pane_cmd; do
                echo "session=$session window=$win_idx window_name=$win_name pane=$pane_idx dir=$pane_dir cmd=$pane_cmd" \
                    >> "$SAVE_FILE"
            done
        done
    done

    echo "✅  Saved $(wc -l < "$SAVE_FILE") pane(s) → $SAVE_FILE"
}

# ── RESTORE ───────────────────────────────────────────────────────────────────
restore_sessions() {
    if [[ ! -f "$SAVE_FILE" ]]; then
        echo "❌  Save file not found: $SAVE_FILE"
        exit 1
    fi

    declare -A created_sessions
    declare -A created_windows

    while IFS= read -r line; do
        [[ -z "$line" ]] && continue

        session=$(echo "$line"   | grep -oP 'session=\K\S+')
        win_idx=$(echo "$line"   | grep -oP 'window=\K\S+')
        win_name=$(echo "$line"  | grep -oP 'window_name=\K\S+')
        pane_idx=$(echo "$line"  | grep -oP 'pane=\K\S+')
        dir=$(echo "$line"       | grep -oP 'dir=\K\S+')
        cmd=$(echo "$line"       | grep -oP 'cmd=\K\S+')

        [[ -d "$dir" ]] || dir="$HOME"

        win_key="${session}:${win_idx}"

        if [[ -z "${created_sessions[$session]}" ]]; then
            if tmux has-session -t "$session" 2>/dev/null; then
                echo "⚠️   Session '$session' already exists — skipping creation"
            else
                tmux new-session -d -s "$session" -n "$win_name" -c "$dir"
                if [[ -n "$cmd" && "$cmd" != "bash" && "$cmd" != "zsh" && "$cmd" != "sh" && "$cmd" != "fish" ]]; then
                    tmux send-keys -t "${session}:${win_idx}.${pane_idx}" "$cmd" Enter
                fi
            fi
            created_sessions[$session]=1
            created_windows[$win_key]=1
            continue
        fi

        if [[ -z "${created_windows[$win_key]}" ]]; then
            tmux new-window -t "$session" -n "$win_name" -c "$dir"
            tmux move-window -s "${session}:{end}" -t "${session}:${win_idx}" 2>/dev/null || true
            created_windows[$win_key]=1
            if [[ -n "$cmd" && "$cmd" != "bash" && "$cmd" != "zsh" && "$cmd" != "sh" && "$cmd" != "fish" ]]; then
                tmux send-keys -t "${session}:${win_idx}.0" "$cmd" Enter
            fi
            continue
        fi

        tmux split-window -t "${session}:${win_idx}" -c "$dir"
        if [[ -n "$cmd" && "$cmd" != "bash" && "$cmd" != "zsh" && "$cmd" != "sh" && "$cmd" != "fish" ]]; then
            tmux send-keys -t "${session}:${win_idx}.${pane_idx}" "$cmd" Enter
        fi

    done < "$SAVE_FILE"

    echo "✅  Sessions restored from $SAVE_FILE"
    echo "👉  Attach with: tmux attach -t <session_name>"
    tmux list-sessions 2>/dev/null
}

# ── ENTRY POINT ───────────────────────────────────────────────────────────────
case "${1:-}" in
    save)    save_sessions    ;;
    restore) restore_sessions ;;
    *)
        echo "Usage: $(basename "$0") <save|restore> [file]"
        echo ""
        echo "  $(basename "$0") save             # save to ~/.tmux-sessions"
        echo "  $(basename "$0") restore          # restore from ~/.tmux-sessions"
        echo "  $(basename "$0") save ~/my-file   # save to custom file"
        echo "  $(basename "$0") restore ~/my-file"
        exit 1
        ;;
esac
