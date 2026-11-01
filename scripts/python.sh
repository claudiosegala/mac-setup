#!/bin/bash
set -euo pipefail
# shellcheck source=scripts/common.sh
. "$(dirname "$0")/common.sh"
init_task python
require_command uv
previous=$(uv python find "$PYTHON_VERSION" --managed-python 2>/dev/null || true)
status=INSTALLED
run_logged 'Install/configure Python' uv python install "$PYTHON_VERSION" --default
run_logged 'Find managed Python' uv python find "$PYTHON_VERSION" --managed-python
interpreter=$(tail -n 1 "$LAST_LOG")
[ "$interpreter" != "$previous" ] || status=PRESENT
[ -x "$interpreter" ] || die 'Managed Python interpreter is missing'
run_logged 'Verify managed Python' "$interpreter" --version
result "$status" "Managed $(cat "$LAST_LOG")" "$LAST_LOG"
for name in python python3; do
  executable="$HOME/.local/bin/$name"
  [ -x "$executable" ] || die "Missing Python default: $executable"
  run_logged "Verify $name default" "$executable" --version
  result CONFIGURED "$name default: $(cat "$LAST_LOG")" "$LAST_LOG"
done
