#!/usr/bin/env bash
set -Eeuo pipefail

REPO_URL="https://github.com/nateleavitt/dotfiles.git"
INSTALL_DIR="$HOME/.dotfiles"

log() {
  printf "%s\n" "$*"
}

die() {
  printf "Error: %s\n" "$*" >&2
  exit 1
}

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux) echo "linux" ;;
    *) die "Unsupported operating system: $(uname -s)" ;;
  esac
}

ensure_git() {
  if command -v git >/dev/null 2>&1; then
    return 0
  fi

  local os
  os="$(detect_os)"

  if [[ "${os}" == "macos" ]]; then
    log "git is not installed yet."
    log "Starting Xcode Command Line Tools installer..."
    xcode-select --install || true
    log "Re-run this install command after Xcode Command Line Tools finishes installing."
    exit 0
  fi

  log "git is not installed yet. Installing git with apt..."
  sudo apt update
  sudo apt install -y git
}

main() {
  log "Starting dotfiles installer..."
  log "Install directory: ${INSTALL_DIR}"

  ensure_git

  if [[ -d "${INSTALL_DIR}" ]]; then
    log "Found existing install at ${INSTALL_DIR}; reusing it."
  else
    log "Cloning ${REPO_URL} into ${INSTALL_DIR}..."
    git clone "${REPO_URL}" "${INSTALL_DIR}" || die "git clone failed for ${REPO_URL}"
  fi

  cd "${INSTALL_DIR}" || die "Failed to cd into ${INSTALL_DIR}"

  if [[ ! -x "./setup/bootstrap.sh" ]]; then
    die "Missing executable setup/bootstrap.sh in ${INSTALL_DIR}"
  fi

  log "Running setup/bootstrap.sh..."
  exec ./setup/bootstrap.sh "$@"
}

main "$@"
