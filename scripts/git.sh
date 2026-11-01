#!/bin/bash
set -euo pipefail
# shellcheck source=scripts/common.sh
. "$(dirname "$0")/common.sh"
init_task git
require_command git
git_setting() {
  local key=$1 value=$2 mode=${3:-default} current status=CONFIGURED
  current=$(git config --global --get "$key" || true)
  if [ "$mode" = default ] && git config --global --get "$key" > /dev/null 2>&1; then
    result PRESERVED "Git $key: $current"
    return
  fi
  [ "$current" != "$value" ] || status=PRESENT
  git config --global "$key" "$value"
  [ "$(git config --global --get "$key")" = "$value" ] || die "Git verification failed: $key"
  result "$status" "Git $key: $value"
}
for field in name email; do
  if [ "$field" = name ]; then value=$GIT_NAME; else value=$GIT_EMAIL; fi
  if [ -n "$value" ]; then git_setting "user.$field" "$value" explicit
  elif git config --global --get "user.$field" > /dev/null 2>&1; then
    result PRESERVED "Git user.$field"
  else result SKIPPED "Git user.$field unset; edit config/options.sh"; fi
done
git_setting init.defaultBranch main
if command -v code > /dev/null 2>&1; then
  git_setting core.editor 'code --wait'
  if command -v gh > /dev/null 2>&1; then
    if gh config get editor > /dev/null 2>&1; then result PRESERVED 'GitHub CLI editor'
    else
      gh config set editor 'code --wait'
      [ "$(gh config get editor)" = 'code --wait' ] || die 'GitHub CLI editor verification failed'
      result CONFIGURED 'GitHub CLI editor'
    fi
  else result SKIPPED 'GitHub CLI editor: gh missing'; fi
else result SKIPPED 'Git editor: code missing'; fi
git_setting alias.co checkout
git_setting alias.br branch
git_setting alias.ci commit
git_setting alias.st status
git_setting alias.ff 'merge --ff-only'
git_setting alias.undo 'reset --soft HEAD^'
git_setting alias.stash-all 'stash push --include-untracked'
format='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
git_setting alias.glog "log --graph --pretty=format:'$format'"
ignore=$(git config --global --path --get core.excludesfile || true)
[ -n "$ignore" ] || ignore="$HOME/.gitignore_global"
append_once "$ignore" '.DS_Store' 'Global .DS_Store ignore'
git_setting core.excludesfile "$ignore"
