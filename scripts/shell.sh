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
  cat <<'ENV'
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH";;
esac
ENV
} > "$expected"
copy_if_changed "$expected" "$envfile" 'Shell environment file'
# shellcheck disable=SC2016
line='[ ! -r "$HOME/.config/mac-setup/env.sh" ] || . "$HOME/.config/mac-setup/env.sh"'
append_once "$HOME/.zprofile" "$line" 'Zsh startup environment'
append_once "$HOME/.bash_profile" "$line" 'Bash startup environment'
code="$APPLICATIONS_DIR/Visual Studio Code.app/Contents/Resources/app/bin/code"
if [ -x "$code" ]; then
  wrapper="$LOGDIR/code-expected.sh"
  printf '#!/bin/bash\nexec %q "$@"\n' "$code" > "$wrapper"
  copy_if_changed "$wrapper" "$HOME/.local/bin/code" 'VS Code command launcher' 1
  run_logged 'Verify code launcher' "$HOME/.local/bin/code" --version
else
  result BLOCKED 'VS Code command launcher requires Visual Studio Code'
  exit 1
fi
