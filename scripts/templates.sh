#!/bin/bash
set -euo pipefail
# shellcheck source=scripts/common.sh
. "$(dirname "$0")/common.sh"
init_task templates
copy_if_missing "$SETUP_ROOT/config/icpc/code.cpp" "$HOME/.icpc/code.cpp" 'C++ starter'
copy_if_missing "$SETUP_ROOT/config/icpc/Makefile" "$HOME/.icpc/Makefile" 'C++ starter Makefile'
