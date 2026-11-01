#!/bin/bash
# Works with macOS's built-in Bash. No Python/Node required to start.
[ -n "${BASH_VERSION:-}" ] || exec /bin/bash "$0" "$@"
set -euo pipefail
# shellcheck source=scripts/common.sh
. "$(dirname "$0")/scripts/common.sh"
[ "$#" -le 1 ] || { echo 'Only one option is accepted.' >&2; exit 2; }
case "${1:-}" in
  --dry-run|--list)
    cat "$SETUP_ROOT/Brewfile"
    echo 'Also: managed Python, pi, gopls, VS Code extensions, shell/Git/app settings, C++ starter.'
    echo "Optional Rust: $INSTALL_RUST_TOOLCHAIN; optional GCC: $INSTALL_GCC"
    exit 0;;
  --help|-h) echo 'Usage: bash setup-mac.sh [--dry-run | --list | --verbose]'; exit 0;;
  --verbose) VERBOSE=1; export VERBOSE;;
  '') ;;
  *) echo "Unknown option: $1" >&2; exit 2;;
esac
init_task setup
START=$SECONDS
if [ "$USE_SUDO" = 1 ]; then
  print_wrapped 'Cache administrator authentication for this run'
  sudo -v || die 'Administrator authentication failed'
  (while :; do sudo -n -v || exit; sleep 45; done) &
  # Read by the EXIT handler in scripts/common.sh.
  # shellcheck disable=SC2034
  SUDO_PID=$!
fi
# Bootstrap is required; other tasks independently report failures and blocked prerequisites.
/bin/bash "$SETUP_ROOT/scripts/bootstrap.sh" || die 'Bootstrap failed; remaining tasks cannot run'
find_brew || die 'Homebrew was not found after bootstrap'
if [ "$UPDATE_HOMEBREW" = 1 ]; then
  if run_logged 'Update Homebrew metadata' "$BREW" update; then result CONFIGURED 'Homebrew metadata'; fi
else
  result SKIPPED 'Homebrew metadata update (set UPDATE_HOMEBREW=1 to opt in)'
fi
for task in packages python pi shell git templates vscode ghostty; do
  /bin/bash "$SETUP_ROOT/scripts/$task.sh" || true
done
if "$BREW" doctor > "$LOGDIR/doctor.log" 2>&1; then
  print_wrapped 'Homebrew doctor: no warnings'
else
  print_wrapped "Homebrew doctor has advisory warnings; review $LOGDIR/doctor.log"
fi
print_wrapped "Finished in $((SECONDS - START)) seconds"
while IFS= read -r line || [ -n "$line" ]; do print_wrapped "$line"; done < "$SETUP_ROOT/config/finish.txt"
# The session EXIT trap prints the summary and fails the run if any required item failed or was blocked.
