#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/lib"

source "${LIB_DIR}/common.sh"

usage() {
  cat <<'EOF'
Usage: setup/bootstrap.sh [options]

Options:
  --dry-run         Print commands without executing them
  --verbose         Enable verbose logs
  --only SECTION    Run only one section
  --skip SECTION    Skip section (repeatable or comma-separated)
  -h, --help        Show this help

Sections:
  shell runtime editor git dotfiles extras python

  python (pyenv) is optional: set INSTALL_PYENV=1 for a full run, or use --only python.
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run)
        DRY_RUN=true
        shift
        ;;
      --verbose)
        VERBOSE=true
        shift
        ;;
      --only)
        [[ $# -ge 2 ]] || die "--only requires a section"
        ONLY_SECTION="$2"
        shift 2
        ;;
      --skip)
        [[ $# -ge 2 ]] || die "--skip requires a section"
        IFS=',' read -r -a _skip_parts <<<"$2"
        SKIP_SECTIONS+=("${_skip_parts[@]}")
        shift 2
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "Unknown argument: $1"
        ;;
    esac
  done
}

validate_sections() {
  local valid_sections=(shell runtime editor git dotfiles extras python)
  local candidate
  local ok

  if [[ -n "${ONLY_SECTION}" ]]; then
    ok=false
    for candidate in "${valid_sections[@]}"; do
      if [[ "${ONLY_SECTION}" == "${candidate}" ]]; then
        ok=true
        break
      fi
    done
    [[ "${ok}" == "true" ]] || die "Invalid --only section: ${ONLY_SECTION}"
  fi

  if [[ ${#SKIP_SECTIONS[@]} -gt 0 ]]; then
    for candidate in "${SKIP_SECTIONS[@]}"; do
      ok=false
      for section in "${valid_sections[@]}"; do
        if [[ "${candidate}" == "${section}" ]]; then
          ok=true
          break
        fi
      done
      [[ "${ok}" == "true" ]] || die "Invalid --skip section: ${candidate}"
    done
  fi
}

detect_platform() {
  case "$(uname -s)" in
    Darwin)
      PLATFORM="darwin"
      source "${LIB_DIR}/macos.sh"
      ;;
    Linux)
      PLATFORM="linux"
      source "${LIB_DIR}/linux.sh"
      ;;
    *)
      die "Unsupported OS: $(uname -s)"
      ;;
  esac
}

run_plan() {
  if [[ "${PLATFORM}" == "darwin" ]]; then
    run_section shell macos_shell
    run_section dotfiles macos_dotfiles
    run_section runtime macos_runtime
    run_section python macos_python
    run_section editor macos_editor
    run_section git macos_git
    run_section extras macos_extras
  else
    run_section shell linux_shell
    run_section dotfiles linux_dotfiles
    run_section runtime linux_runtime
    run_section python linux_python
    run_section editor linux_editor
    run_section git linux_git
    run_section extras linux_extras
  fi
}

main() {
  parse_args "$@"
  validate_sections
  detect_platform

  log ""
  log "*******************************************************"
  if [[ "${PLATFORM}" == "darwin" ]]; then
    log "${GREEN}Welcome to nateleavitt's macOS setup script${NC}"
  else
    log "${GREEN}Welcome to nateleavitt's Linux setup script${NC}"
  fi
  log "*******************************************************"

  run_plan

  log ""
  log "*******************************************************"
  printf "%b\n" "${GREEN}Everything is now setup!${NC}"
  log "Let me know if you have any questions:"
  log "https://github.com/nateleavitt/dotfiles"
  printf "%b\n" "${GREEN}Thank you!${NC}"
  if [[ "${PLATFORM}" == "linux" ]]; then
    log "Note: run 'gcloud init' to initialize gcloud"
  fi
  log "*******************************************************"
  log ""
}

main "$@"
