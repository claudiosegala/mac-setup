#!/bin/bash
set -euo pipefail
# shellcheck source=scripts/common.sh
. "$(dirname "$0")/common.sh"
init_task bootstrap
if find_brew; then
  run_logged 'Homebrew verification' "$BREW" --version
  result PRESENT "Homebrew: $(head -n 1 "$LAST_LOG")"
  exit 0
fi
require_command curl
installer="$LOGDIR/homebrew-installer.sh"
run_logged 'Download Homebrew installer' curl --fail --location --retry 3 --connect-timeout 20 \
  https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$installer"
run_logged 'Install Homebrew and Command Line Tools' /bin/bash "$installer"
find_brew || die 'Homebrew was not found after installation'
run_logged 'Homebrew verification' "$BREW" --version
result INSTALLED "Homebrew: $(head -n 1 "$LAST_LOG")"
