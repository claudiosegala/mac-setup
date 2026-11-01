#!/bin/bash
set -euo pipefail
# shellcheck source=scripts/common.sh
. "$(dirname "$0")/common.sh"
init_task python
require_command uv
status=PRESENT
interpreter=$(uv python find "$PYTHON_VERSION" --managed-python --no-python-downloads 2>/dev/null || true)
if [ ! -x "$interpreter" ]; then
  run_logged 'Install managed Python' uv python install "$PYTHON_VERSION" --no-bin
  run_logged 'Find managed Python' uv python find "$PYTHON_VERSION" --managed-python --no-python-downloads
  interpreter=$(tail -n 1 "$LAST_LOG")
  status=INSTALLED
fi
[ -x "$interpreter" ] || die 'Managed Python interpreter is missing'
run_logged 'Verify managed Python' "$interpreter" --version
result "$status" "Managed $(cat "$LAST_LOG")" "$LAST_LOG"
# Retarget only links previously recorded by setup; never overwrite another Python command.
marker="$HOME/.config/mac-setup/python-interpreter"
previous=''
[ ! -f "$marker" ] || previous=$(cat "$marker")
mkdir -p "$HOME/.local/bin"
for name in python python3; do
  executable="$HOME/.local/bin/$name"
  status=PRESENT
  if [ "$executable" -ef "$interpreter" ]; then :
  elif [ ! -e "$executable" ] && [ ! -L "$executable" ]; then
    ln -s "$interpreter" "$executable"
    status=CONFIGURED
  elif [ -L "$executable" ] && [ -n "$previous" ] && [ "$(readlink "$executable")" = "$previous" ]; then
    ln -sf "$interpreter" "$executable"
    status=CONFIGURED
  else
    die "Python default conflicts with $executable; move it aside explicitly and rerun"
  fi
  [ "$executable" -ef "$interpreter" ] || die "Python default verification failed: $name"
  run_logged "Verify $name default" "$executable" --version
  result "$status" "$name default: $(cat "$LAST_LOG")" "$LAST_LOG"
done
printf '%s\n' "$interpreter" > "$LOGDIR/python-interpreter-expected"
copy_if_changed "$LOGDIR/python-interpreter-expected" "$marker" 'Python default ownership record'
