# shellcheck shell=bash
# Shared session and configuration helpers; compatible with macOS Bash 3.2.
SETUP_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
export SETUP_ROOT
# shellcheck source=config/options.sh
. "$SETUP_ROOT/config/options.sh"
# shellcheck source=scripts/output.sh
. "$SETUP_ROOT/scripts/output.sh"
FAIL_REPORTED=0
COMMAND_NUMBER=0
SUDO_PID=''

find_brew() {
  if [ -n "${BREW:-}" ] && [ -x "$BREW" ]; then :
  elif command -v brew >/dev/null 2>&1; then BREW=$(command -v brew)
  elif [ -x /opt/homebrew/bin/brew ]; then BREW=/opt/homebrew/bin/brew
  elif [ -x /usr/local/bin/brew ]; then BREW=/usr/local/bin/brew
  else return 1; fi
  export BREW
  eval "$("$BREW" shellenv)"
  export PATH="$HOME/.local/bin:$PATH"
  export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_CLEANUP=1 HOMEBREW_NO_INSTALL_UPGRADE=1
  export HOMEBREW_NO_ENV_HINTS=1 NONINTERACTIVE=1
}
session_exit() {
  local status=$?
  trap - EXIT
  [ -z "$SUDO_PID" ] || kill "$SUDO_PID" 2>/dev/null || true
  if [ "$status" -ne 0 ] && [ "$FAIL_REPORTED" = 0 ]; then
    result FAILED "$TASK_NAME stopped (exit $status)"
  fi
  summary || status=1
  rmdir "$LOCK" 2>/dev/null || true
  exit "$status"
}
task_exit() {
  local status=$?
  if [ "$status" -ne 0 ] && [ "$FAIL_REPORTED" = 0 ]; then
    result FAILED "$TASK_NAME stopped (exit $status)"
  fi
}
init_task() {
  TASK_NAME=$1
  [ "$(uname -s)" = Darwin ] || { echo 'Run on macOS.' >&2; exit 1; }
  [ "$(id -u)" != 0 ] || { echo 'Run as your normal user, without sudo bash.' >&2; exit 1; }
  if [ "${SETUP_SESSION:-0}" != 1 ]; then
    mkdir -p "$HOME/Library/Logs/mac-setup"
    LOCK="$HOME/Library/Logs/mac-setup/running.lock"
    mkdir "$LOCK" 2>/dev/null || { echo "Setup already running; inspect $LOCK" >&2; exit 1; }
    trap 'rmdir "$LOCK" 2>/dev/null || true' EXIT
    umask 077
    LOGDIR=$(mktemp -d "$HOME/Library/Logs/mac-setup/run-XXXXXXXX")
    export LOGDIR SETUP_SESSION=1
    : > "$LOGDIR/results.tsv"
    trap session_exit EXIT
    trap 'exit 130' INT
    trap 'exit 143' TERM
  else
    trap task_exit EXIT
  fi
  find_brew || true
}
die() { result FAILED "$*"; exit 1; }
require_command() {
  command -v "$1" >/dev/null 2>&1 && return 0
  result BLOCKED "$TASK_NAME requires $1; run setup-mac.sh or install that prerequisite first"
  exit 1
}
run_logged() {
  local label=$1 status
  shift
  COMMAND_NUMBER=$((COMMAND_NUMBER + 1))
  LAST_LOG="$LOGDIR/$TASK_NAME-$$-$COMMAND_NUMBER.log"
  if "$@" > "$LAST_LOG" 2>&1; then
    [ "$VERBOSE" = 0 ] || cat "$LAST_LOG"
    return 0
  else
    status=$?
    result FAILED "$label (exit $status)" "$LAST_LOG"
    [ "$VERBOSE" = 0 ] || cat "$LAST_LOG"
    return "$status"
  fi
}
copy_if_missing() {
  local source=$1 target=$2 label=${3:-$2}
  mkdir -p "$(dirname "$target")"
  if [ -e "$target" ] || [ -L "$target" ]; then
    result PRESERVED "$label"
  else
    cp "$source" "$target"
    cmp -s "$source" "$target" || die "Verification failed: $label"
    result CONFIGURED "$label"
  fi
}
append_once() {
  local target=$1 line=$2 label=${3:-$1} status=PRESENT
  mkdir -p "$(dirname "$target")"
  touch "$target"
  if ! /usr/bin/grep -Fqx -- "$line" "$target"; then
    printf '\n%s\n' "$line" >> "$target"
    status=CONFIGURED
  fi
  /usr/bin/grep -Fqx -- "$line" "$target" || die "Verification failed: $label"
  result "$status" "$label"
}
