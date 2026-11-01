# shellcheck shell=bash
# Shared status output. Raw command logs are intentionally not wrapped.
print_wrapped() { printf '%s\n' "$*" | fold -s -w 120; }
result() {
  local status=$1 message=$2 log=${3:-}
  message=${message//$'\n'/ }
  message=${message//$'\t'/ }
  printf '%s\t%s\t%s\n' "$status" "$message" "$log" >> "$LOGDIR/results.tsv"
  print_wrapped "[$status] $message"
  if [ "$status" = FAILED ] || [ "$status" = BLOCKED ]; then
    # Read by session/task EXIT handlers in common.sh.
    # shellcheck disable=SC2034
    FAIL_REPORTED=1
    [ -z "$log" ] || print_wrapped "  Log: $log"
  fi
}
summary() {
  local counts
  counts=$(awk -F '\t' '
    { count[$1]++ }
    END {
      printf "Installed: %d; present: %d; configured: %d; preserved: %d; skipped: %d; failed: %d; blocked: %d", \
        count["INSTALLED"], count["PRESENT"], count["CONFIGURED"], count["PRESERVED"], \
        count["SKIPPED"], count["FAILED"], count["BLOCKED"]
    }' "$LOGDIR/results.tsv")
  print_wrapped "$counts"
  print_wrapped "Results and command logs: $LOGDIR"
  ! awk -F '\t' '$1 == "FAILED" || $1 == "BLOCKED" { found = 1 } END { exit !found }' "$LOGDIR/results.tsv"
}
