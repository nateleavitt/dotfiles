#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;93m'
NC='\033[0m'

DRY_RUN=false
VERBOSE=false
ONLY_SECTION=""
SKIP_SECTIONS=()
DEV_ROOT="${DEV_ROOT:-$HOME/Code}"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

DOTFILES_ROOT_DEFAULT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

die() {
  printf "\n${RED}%s${NC}\n" "$*" >&2
  exit 1
}

log() {
  printf "%b\n" "$*"
}

verbose_log() {
  if [[ "${VERBOSE}" == "true" ]]; then
    printf "${YELLOW}[verbose]${NC} %s\n" "$*"
  fi
}

run_cmd() {
  local rendered=""
  local arg
  for arg in "$@"; do
    if [[ -n "${rendered}" ]]; then
      rendered+=" "
    fi
    rendered+="$(printf '%q' "${arg}")"
  done
  if [[ "${DRY_RUN}" == "true" ]]; then
    printf "${YELLOW}[dry-run]${NC} %s\n" "${rendered}"
    return 0
  fi
  verbose_log "running: ${rendered}"
  "$@"
}

run_cmd_shell() {
  local cmd="$1"
  if [[ "${DRY_RUN}" == "true" ]]; then
    printf "${YELLOW}[dry-run]${NC} %s\n" "${cmd}"
    return 0
  fi
  verbose_log "running: ${cmd}"
  bash -lc "${cmd}"
}

donemsg() {
  printf "${GREEN}DONE!${NC}\n"
}

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

backup_if_exists() {
  local target="$1"
  if [[ -e "${target}" || -L "${target}" ]]; then
    local backup="${target}.bak.${TIMESTAMP}"
    log "Backing up ${target} -> ${backup}"
    run_cmd mv "${target}" "${backup}" || die "Could not back up ${target}"
  fi
}

safe_symlink() {
  local source="$1"
  local target="$2"

  if [[ ! -e "${source}" && ! -L "${source}" ]]; then
    die "Source path does not exist: ${source}"
  fi

  if [[ -L "${target}" ]]; then
    local current_link
    current_link="$(readlink "${target}")"
    if [[ "${current_link}" == "${source}" ]]; then
      verbose_log "Link already correct: ${target}"
      return 0
    fi
  fi

  backup_if_exists "${target}"
  run_cmd ln -s "${source}" "${target}"
}

ensure_dir() {
  run_cmd mkdir -p "$1"
}

ensure_dirs() {
  local dir
  for dir in "$@"; do
    ensure_dir "${dir}"
  done
}

append_if_missing() {
  local file="$1"
  local line="$2"

  ensure_dir "$(dirname "${file}")"
  if [[ ! -f "${file}" ]]; then
    run_cmd touch "${file}"
  fi

  # Use grep (not rg) so dedupe works on minimal Linux/WSL without ripgrep.
  if grep -Fqx -- "${line}" "${file}" 2>/dev/null; then
    verbose_log "Line already present in ${file}: ${line}"
    return 0
  fi

  if [[ "${DRY_RUN}" == "true" ]]; then
    printf "${YELLOW}[dry-run]${NC} append to %s: %s\n" "${file}" "${line}"
    return 0
  fi

  printf "%s\n" "${line}" >> "${file}"
}

ensure_git_config() {
  local key="$1"
  local value="$2"

  local current_value=""
  current_value="$(git config --global --get "${key}" 2>/dev/null || true)"
  if [[ "${current_value}" == "${value}" ]]; then
    verbose_log "Git config already set: ${key}=${value}"
    return 0
  fi

  run_cmd git config --global "${key}" "${value}"
}

install_vim_plugins() {
  local vundle_dir="$HOME/.vim/bundle/Vundle.vim"
  if [[ ! -d "${vundle_dir}" ]]; then
    run_cmd git clone https://github.com/gmarik/Vundle.vim.git "${vundle_dir}"
  else
    verbose_log "Vundle already installed at ${vundle_dir}"
  fi

  if has_cmd vim; then
    run_cmd vim +PluginInstall +qall || true
  else
    verbose_log "vim is not available, skipping plugin install"
  fi
}

ensure_dotfiles_dir() {
  if [[ -d "${DOTFILES_DIR}" ]]; then
    verbose_log "Using existing dotfiles dir: ${DOTFILES_DIR}"
    return 0
  fi

  if [[ -d "$HOME/dotfiles" ]]; then
    if [[ "${DRY_RUN}" == "true" ]]; then
      log "Would move $HOME/dotfiles to ${DOTFILES_DIR} (dry-run). Using $HOME/dotfiles for source resolution."
      DOTFILES_DIR="$HOME/dotfiles"
      return 0
    fi

    log "Moving $HOME/dotfiles to ${DOTFILES_DIR}"
    run_cmd mv "$HOME/dotfiles" "${DOTFILES_DIR}"
    return 0
  fi

  if [[ -d "${DOTFILES_ROOT_DEFAULT}" ]]; then
    DOTFILES_DIR="${DOTFILES_ROOT_DEFAULT}"
    verbose_log "Using repository root as dotfiles dir: ${DOTFILES_DIR}"
    return 0
  fi

  die "Unable to find dotfiles directory"
}

section_enabled() {
  local section="$1"
  local skip

  if [[ -n "${ONLY_SECTION}" && "${ONLY_SECTION}" != "${section}" ]]; then
    return 1
  fi

  if [[ ${#SKIP_SECTIONS[@]} -gt 0 ]]; then
    for skip in "${SKIP_SECTIONS[@]}"; do
      if [[ "${skip}" == "${section}" ]]; then
        return 1
      fi
    done
  fi

  # Optional python (pyenv): skipped on full runs unless INSTALL_PYENV=1,
  # or when explicitly selected with --only python.
  if [[ "${section}" == "python" ]]; then
    if [[ -z "${ONLY_SECTION}" || "${ONLY_SECTION}" != "python" ]]; then
      if [[ "${INSTALL_PYENV:-}" != "1" ]]; then
        return 1
      fi
    fi
  fi

  return 0
}

run_section() {
  local section="$1"
  local fn="$2"

  if ! section_enabled "${section}"; then
    verbose_log "Skipping section '${section}'"
    return 0
  fi

  log ""
  log "==> ${section}: ${fn}"
  "${fn}"
  donemsg
}

configure_dotfiles_links() {
  ensure_dotfiles_dir

  ensure_dirs "$HOME/.oh-my-zsh/custom" "$HOME/.config/Code/User"

  safe_symlink "${DOTFILES_DIR}/vim" "$HOME/.vim"
  safe_symlink "${DOTFILES_DIR}/vim/vimrc" "$HOME/.vimrc"
  safe_symlink "${DOTFILES_DIR}/vim/gvimrc" "$HOME/.gvimrc"
  safe_symlink "${DOTFILES_DIR}/vim/gvimrc.before" "$HOME/.gvimrc.before"
  safe_symlink "${DOTFILES_DIR}/vim/gvimrc.after" "$HOME/.gvimrc.after"
  safe_symlink "${DOTFILES_DIR}/vim/vimrc.before" "$HOME/.vimrc.before"
  safe_symlink "${DOTFILES_DIR}/vim/vimrc.after" "$HOME/.vimrc.after"
  safe_symlink "${DOTFILES_DIR}/git/gitignore_global" "$HOME/.gitignore_global"
  safe_symlink "${DOTFILES_DIR}/zsh/zshrc" "$HOME/.zshrc"
  safe_symlink "${DOTFILES_DIR}/zsh/custom/aliases.zsh" "$HOME/.oh-my-zsh/custom/aliases.zsh"
  safe_symlink "${DOTFILES_DIR}/zsh/custom/completions.zsh" "$HOME/.oh-my-zsh/custom/completions.zsh"
  safe_symlink "${DOTFILES_DIR}/zsh/custom/exports.zsh" "$HOME/.oh-my-zsh/custom/exports.zsh"
}

create_dev_environment() {
  ensure_dirs \
    "${DEV_ROOT}" \
    "${DEV_ROOT}/github.com" \
    "${DEV_ROOT}/github.com/nateleavitt" \
    "${DEV_ROOT}/github.com/loyalstream" \
    "$HOME/.config/Code/User"
}

configure_git() {
  ensure_git_config core.excludesfile "$HOME/.gitignore_global"
  ensure_git_config pager.branch false
}

configure_rbenv_in_zshrc() {
  local zshrc="$HOME/.zshrc"
  # Repo zshrc (and many setups) already configure rbenv with different formatting than
  # the two legacy lines below — exact append_if_missing would never match and would
  # duplicate on every bootstrap. Skip when rbenv is already referenced.
  if [[ -f "$zshrc" ]] && grep -Eq '\.rbenv|rbenv init' "$zshrc" 2>/dev/null; then
    verbose_log "rbenv already referenced in ${zshrc}; skipping PATH/init append."
    return 0
  fi
  append_if_missing "$zshrc" 'export PATH="$HOME/.rbenv/bin:$PATH"'
  append_if_missing "$zshrc" 'eval "$(rbenv init -)"'
}
