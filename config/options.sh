# shellcheck shell=bash
# Set preferences here once; all installation runs remain non-interactive.
# Leave identity empty to preserve existing Git identity.
export GIT_NAME="${GIT_NAME:-}"
export GIT_EMAIL="${GIT_EMAIL:-}"
export PYTHON_VERSION="${PYTHON_VERSION:-3}"  # newest stable on first install; reuse matching Python on reruns
export INSTALL_RUST_TOOLCHAIN="${INSTALL_RUST_TOOLCHAIN:-0}"
export INSTALL_GCC="${INSTALL_GCC:-0}"      # GNU bits/stdc++.h; large download
export USE_SUDO="${USE_SUDO:-1}"
export VERBOSE="${VERBOSE:-0}"
export APPLICATIONS_DIR="${APPLICATIONS_DIR:-/Applications}"
export PROJECTS_DIR="${PROJECTS_DIR:-$HOME/Projects}"
# Metadata refresh is explicit; normal reruns verify existing installations without updating them.
export UPDATE_HOMEBREW="${UPDATE_HOMEBREW:-0}"
