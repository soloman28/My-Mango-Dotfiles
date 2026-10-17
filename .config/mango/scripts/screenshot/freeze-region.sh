#!/usr/bin/env bash
pipe=$(mktemp -u).fifo
mkfifo "$pipe"
wayfreeze --after-freeze-timeout 100 --after-freeze-cmd "echo > $pipe" &
wayfreeze_pid=$!
read -r < "$pipe"
geometry=$(slurp -d)
if [[ -z "$geometry" ]]; then
  kill "$wayfreeze_pid" 2>/dev/null
  rm -f "$pipe"
  exit 1
fi
grim -g "$geometry" "$HOME/Pictures/Screenshots/screenshot_$(date +%Y%m%d_%H%M%S)-region.png" && notify-send 'New screenshot!'
kill "$wayfreeze_pid" 2>/dev/null
rm -f "$pipe"
