#!/usr/bin/env bash

install_homebrew() {
  if has_cmd brew; then
    verbose_log "Homebrew already installed"
    return 0
  fi
  run_cmd_shell '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
}

install_oh_my_zsh_macos() {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    run_cmd_shell 'RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
  else
    verbose_log "oh-my-zsh already installed"
  fi

  if [[ "${DRY_RUN}" == "true" ]]; then
    log "Skipping chsh in dry-run mode."
    return 0
  fi

  if [[ "${SHELL}" == "/bin/zsh" ]]; then
    verbose_log "Login shell already set to zsh"
    return 0
  fi

  if ! has_cmd chsh; then
    log "Warning: chsh not available; leaving default shell unchanged."
    return 0
  fi

  if [[ ! -t 0 ]]; then
    log "Warning: non-interactive session; skipping chsh."
    return 0
  fi

  run_cmd chsh -s /bin/zsh
}

install_ruby_macos() {
  if ! has_cmd brew; then
    die "Homebrew is required for macOS runtime installs"
  fi
  run_cmd brew install rbenv ruby-build
}

install_node_macos() {
  if ! has_cmd node; then
    run_cmd brew install node
  else
    verbose_log "node already installed"
  fi
}

install_vscode_macos() {
  run_cmd brew install --cask visual-studio-code
}

install_extras_macos() {
  run_cmd brew install --cask typora
  run_cmd brew install --cask slack
  run_cmd brew install ack
  run_cmd brew install wget
}

apply_macos_defaults() {
  run_cmd defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
  run_cmd defaults write dev.warp.Warp-Stable ApplePressAndHoldEnabled -bool false
  run_cmd defaults write com.apple.dock autohide-delay -float 0
  run_cmd killall Dock || true
}

install_macos_font() {
  if [[ -d "${DOTFILES_DIR}/font" ]]; then
    ensure_dir "$HOME/Library/Fonts"
    run_cmd cp "${DOTFILES_DIR}/font/"*.otf "$HOME/Library/Fonts/" || true
  fi
}

macos_shell() {
  install_homebrew
  install_oh_my_zsh_macos
}

macos_runtime() {
  install_ruby_macos
  install_node_macos
}

install_pyenv_macos() {
  if ! has_cmd brew; then
    die "Homebrew is required to install pyenv on macOS"
  fi
  if has_cmd pyenv; then
    verbose_log "pyenv already installed"
    return 0
  fi
  run_cmd brew install pyenv
}

macos_python() {
  install_pyenv_macos
}

macos_editor() {
  install_vscode_macos
  install_vim_plugins
}

macos_git() {
  configure_git
}

macos_dotfiles() {
  configure_dotfiles_links
  configure_rbenv_in_zshrc
}

macos_extras() {
  install_extras_macos
  create_dev_environment
  apply_macos_defaults
  install_macos_font
}
