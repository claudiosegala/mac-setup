#!/bin/bash
set -euo pipefail
# shellcheck source=scripts/common.sh
. "$(dirname "$0")/common.sh"
init_task vscode
require_command node
code="$APPLICATIONS_DIR/Visual Studio Code.app/Contents/Resources/app/bin/code"
[ -x "$code" ] || { result BLOCKED 'VS Code configuration requires Visual Studio Code'; exit 1; }
run_logged 'Verify VS Code' "$code" --version
user="$HOME/Library/Application Support/Code/User"
if [ -e "$user/settings.json" ] || [ -L "$user/settings.json" ]; then
  result PRESERVED 'VS Code settings'
else
  mkdir -p "$user"
  run_logged 'Write and verify VS Code settings' node - \
    "$SETUP_ROOT/config/vscode/settings.json" "$user/settings.json" <<'NODE'
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const settings = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
settings['go.alternateTools'] = {gopls: path.join(os.homedir(), '.local/bin/gopls')};
settings['python.defaultInterpreterPath'] = path.join(os.homedir(), '.local/bin/python');
const expected = JSON.stringify(settings, null, 2) + '\n';
fs.writeFileSync(process.argv[3], expected);
if (fs.readFileSync(process.argv[3], 'utf8') !== expected) throw new Error('Settings verification failed');
NODE
  result CONFIGURED 'VS Code settings' "$LAST_LOG"
fi
copy_if_missing "$SETUP_ROOT/config/vscode/keybindings.json" "$user/keybindings.json" 'VS Code keybindings'
run_logged 'List VS Code extensions' "$code" --list-extensions
installed=$(cat "$LAST_LOG")
failed=0
while IFS= read -r extension || [ -n "$extension" ]; do
  case "$extension" in ''|'#'*) continue;; esac
  status=INSTALLED
  if printf '%s\n' "$installed" | /usr/bin/grep -Fqix -- "$extension"; then
    status=PRESENT
  elif ! run_logged "Install extension $extension" "$code" --install-extension "$extension"; then
    failed=1
    continue
  fi
  if run_logged "Verify extension $extension" "$code" --list-extensions --show-versions; then
    version=$(/usr/bin/grep -Ei "^${extension//./\\.}@" "$LAST_LOG" || true)
    if [ -n "$version" ]; then
      result "$status" "VS Code extension: $version" "$LAST_LOG"
      installed="$installed
$extension"
    else result FAILED "VS Code extension not found: $extension" "$LAST_LOG"; failed=1; fi
  else failed=1; fi
done < "$SETUP_ROOT/config/vscode/extensions.txt"
if command -v go > /dev/null 2>&1; then
  status=PRESENT
  if [ ! -x "$HOME/.local/bin/gopls" ]; then
    mkdir -p "$HOME/.local/bin"
    status=INSTALLED
    if ! run_logged 'Install gopls' env GOBIN="$HOME/.local/bin" go install golang.org/x/tools/gopls@latest; then
      failed=1
    fi
  fi
  if [ -x "$HOME/.local/bin/gopls" ]; then
    if run_logged 'Verify gopls' "$HOME/.local/bin/gopls" version; then
      result "$status" "$(head -n 1 "$LAST_LOG")" "$LAST_LOG"
    else failed=1; fi
  else result BLOCKED 'gopls verification requires its executable'; failed=1; fi
else result BLOCKED 'gopls requires Go'; failed=1; fi
exit "$failed"
