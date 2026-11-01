#!/bin/bash
set -euo pipefail
# Literal expansions below belong to generated startup files.
# shellcheck source=scripts/common.sh
. "$(dirname "$0")/common.sh"
init_task shell
require_command brew
mkdir -p "$PROJECTS_DIR" "$HOME/.local/bin" "$HOME/.config/mac-setup"
[ -d "$PROJECTS_DIR" ] || die 'Projects directory is missing'
result PRESENT "Projects directory: $PROJECTS_DIR"
# Only this generated file is replaced. Personal startup files are preserved.
envfile="$HOME/.config/mac-setup/env.sh"
expected="$LOGDIR/env-expected.sh"
{
  # shellcheck disable=SC2016
  printf 'eval "$(%q shellenv)"\n' "$BREW"
  # shellcheck disable=SC2016
  echo 'export PATH="$HOME/.local/bin:$PATH"'
} > "$expected"
if cmp -s "$expected" "$envfile"; then
  result PRESENT 'Shell environment file'
else
  cp "$expected" "$envfile"
  cmp -s "$expected" "$envfile" || die 'Shell environment verification failed'
  result CONFIGURED 'Shell environment file'
fi
# shellcheck disable=SC2016
line='[ ! -r "$HOME/.config/mac-setup/env.sh" ] || . "$HOME/.config/mac-setup/env.sh"'
append_once "$HOME/.zprofile" "$line" 'Zsh startup environment'
append_once "$HOME/.bash_profile" "$line" 'Bash startup environment'
code="$APPLICATIONS_DIR/Visual Studio Code.app/Contents/Resources/app/bin/code"
if [ -x "$code" ]; then
  printf '#!/bin/bash\nexec %q "$@"\n' "$code" > "$HOME/.local/bin/code"
  chmod +x "$HOME/.local/bin/code"
  run_logged 'Verify code launcher' "$HOME/.local/bin/code" --version
  result CONFIGURED 'VS Code command launcher' "$LAST_LOG"
else
  result BLOCKED 'VS Code command launcher requires Visual Studio Code'
  exit 1
fi
