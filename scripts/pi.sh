#!/bin/bash
set -euo pipefail
# shellcheck source=scripts/common.sh
. "$(dirname "$0")/common.sh"
init_task pi
require_command npm
mkdir -p "$HOME/.local"
package='@mariozechner/pi-coding-agent'
status=INSTALLED
if npm list --global --prefix "$HOME/.local" "$package" --depth=0 > /dev/null 2>&1; then
  status=PRESENT
  if [ ! -x "$HOME/.local/bin/pi" ]; then
    run_logged 'Repair pi command links' npm rebuild --global --prefix "$HOME/.local" "$package" --bin-links
    result CONFIGURED 'pi command links' "$LAST_LOG"
  fi
else
  run_logged 'Install pi' npm install --global --prefix "$HOME/.local" "$package" --no-fund --no-audit
fi
run_logged 'Verify pi' "$HOME/.local/bin/pi" --version
result "$status" "pi: $(cat "$LAST_LOG")" "$LAST_LOG"
