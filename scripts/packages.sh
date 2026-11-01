#!/bin/bash
set -euo pipefail
# shellcheck source=scripts/common.sh
. "$(dirname "$0")/common.sh"
init_task packages
require_command brew
failed=0
install_package() {
  local kind=$1 package=$2 status=INSTALLED version token args=()
  token=${package##*/}
  if "$BREW" list "--$kind" --versions "$token" > /dev/null 2>&1; then
    status=PRESENT
  else
    [ "$kind" != cask ] || args=("--appdir=$APPLICATIONS_DIR")
    run_logged "Install $package" "$BREW" install "--$kind" ${args[@]+"${args[@]}"} "$package" < /dev/null || return 1
  fi
  run_logged "Verify $package" "$BREW" list "--$kind" --versions "$token" || return 1
  version=$(cat "$LAST_LOG")
  version=${version#* }
  [ -n "${version//[[:space:]]/}" ] || { result FAILED "$package: no installed version found" "$LAST_LOG"; return 1; }
  result "$status" "$package $version" "$LAST_LOG"
}
# Install declared taps first: Homebrew's cask list returns unqualified tokens.
run_logged 'Read tap list' "$BREW" bundle list --file="$SETUP_ROOT/Brewfile" --tap
taps=$LAST_LOG
while IFS= read -r tap || [ -n "$tap" ]; do
  [ -n "$tap" ] || continue
  status=INSTALLED
  if "$BREW" tap | /usr/bin/grep -Fqx -- "$tap"; then
    status=PRESENT
  elif ! run_logged "Install tap $tap" "$BREW" tap "$tap"; then
    failed=1
    continue
  fi
  if run_logged "Verify tap $tap" "$BREW" tap && /usr/bin/grep -Fqx -- "$tap" "$LAST_LOG"; then
    result "$status" "Homebrew tap: $tap" "$LAST_LOG"
  else
    result FAILED "Homebrew tap missing: $tap" "$LAST_LOG"
    failed=1
  fi
done < "$taps"
# Homebrew evaluates the Brewfile; comments and conditional entries remain supported.
run_logged 'Read formula list' "$BREW" bundle list --file="$SETUP_ROOT/Brewfile" --formula
formulas=$LAST_LOG
run_logged 'Read cask list' "$BREW" bundle list --file="$SETUP_ROOT/Brewfile" --cask
casks=$LAST_LOG
for kind in formula cask; do
  if [ "$kind" = formula ]; then list=$formulas; else list=$casks; fi
  while IFS= read -r package || [ -n "$package" ]; do
    [ -n "$package" ] || continue
    install_package "$kind" "$package" || failed=1
  done < "$list"
done
for option in gcc rust; do
  if { [ "$option" = gcc ] && [ "$INSTALL_GCC" = 1 ]; } || \
     { [ "$option" = rust ] && [ "$INSTALL_RUST_TOOLCHAIN" = 1 ]; }; then
    install_package formula "$option" || failed=1
  else
    result SKIPPED "Optional $option toolchain"
  fi
done
exit "$failed"
