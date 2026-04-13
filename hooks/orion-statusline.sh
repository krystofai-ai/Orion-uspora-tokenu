#!/bin/bash
# Orion mode statusline badge
FLAG="$HOME/.claude/.orion-active"

if [ -f "$FLAG" ]; then
  mode=$(cat "$FLAG" 2>/dev/null)
  case "$mode" in
    lite)  echo "⚡ orion:lite" ;;
    ultra) echo "⚡ orion:ultra" ;;
    full)  echo "⚡ orion" ;;
    *)     echo "" ;;
  esac
fi
