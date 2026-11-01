#!/bin/bash
set -euo pipefail
# shellcheck source=scripts/common.sh
. "$(dirname "$0")/common.sh"
init_task ghostty
require_command brew
run_logged 'Verify Ghostty installation' "$BREW" list --cask --versions ghostty
[ -s "$LAST_LOG" ] || die 'Ghostty is not installed'
directory="$HOME/Library/Application Support/com.mitchellh.ghostty"
xdg="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
for location in "$directory/config" "$directory/config.ghostty" "$xdg/config" "$xdg/config.ghostty"; do
  if [ -e "$location" ] || [ -L "$location" ]; then
    result PRESERVED "Ghostty configuration: $location"
    exit 0
  fi
done
copy_if_missing "$SETUP_ROOT/config/ghostty/config.ghostty" "$directory/config.ghostty" 'Ghostty configuration'
