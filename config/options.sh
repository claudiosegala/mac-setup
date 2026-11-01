# shellcheck shell=bash
# Set preferences here once; all installation runs remain non-interactive.
# Leave identity empty to preserve existing Git identity.
export GIT_NAME="${GIT_NAME:-}"
export GIT_EMAIL="${GIT_EMAIL:-}"
export PYTHON_VERSION="${PYTHON_VERSION:-3}"  # newest stable Python 3
export INSTALL_RUST_TOOLCHAIN="${INSTALL_RUST_TOOLCHAIN:-0}"
export INSTALL_GCC="${INSTALL_GCC:-0}"      # GNU bits/stdc++.h; large download
export USE_SUDO="${USE_SUDO:-1}"
export VERBOSE="${VERBOSE:-0}"
export APPLICATIONS_DIR="${APPLICATIONS_DIR:-/Applications}"
export PROJECTS_DIR="${PROJECTS_DIR:-$HOME/Projects}"
