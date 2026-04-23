#!/usr/bin/env bash

apt_update() {
  run_cmd sudo apt -y update
}

install_prereqs_linux() {
  run_cmd sudo apt -y install autoconf bison build-essential libssl-dev libyaml-dev \
    libreadline-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libpq-dev
  run_cmd sudo apt -y install apt-transport-https
  run_cmd sudo apt -y install ca-certificates
  run_cmd sudo apt -y install wget vim ack gdebi curl gnupg
}

install_oh_my_zsh_linux() {
  if ! has_cmd zsh; then
    run_cmd sudo apt -y install zsh
  fi
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    run_cmd_shell 'RUNZSH=no CHSH=no sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"'
  else
    verbose_log "oh-my-zsh already installed"
  fi

  if [[ "${DRY_RUN}" == "true" ]]; then
    log "Skipping chsh in dry-run mode."
    return 0
  fi

  if [[ "${SHELL:-}" == "$(command -v zsh)" ]]; then
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

  run_cmd chsh -s "$(command -v zsh)"
}

install_node_linux() {
  if has_cmd node; then
    verbose_log "node already installed"
    return 0
  fi
  run_cmd_shell 'curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -'
  run_cmd sudo apt-get install -y nodejs
}

install_postgres_linux() {
  run_cmd sudo apt -y install postgresql postgresql-contrib
}

install_rbenv_linux() {
  if [[ ! -d "$HOME/.rbenv" ]]; then
    run_cmd git clone https://github.com/rbenv/rbenv.git "$HOME/.rbenv"
  else
    verbose_log "rbenv already installed"
  fi

  configure_rbenv_in_zshrc

  if [[ ! -d "$HOME/.rbenv/plugins/ruby-build" ]]; then
    run_cmd git clone https://github.com/rbenv/ruby-build.git "$HOME/.rbenv/plugins/ruby-build"
  else
    verbose_log "ruby-build already installed"
  fi
}

install_gcloud_linux() {
  run_cmd sudo apt -y install apt-transport-https ca-certificates gnupg curl
  run_cmd sudo install -m 0755 -d /etc/apt/keyrings
  run_cmd_shell 'curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/google-cloud.gpg'
  run_cmd sudo chmod a+r /etc/apt/keyrings/google-cloud.gpg
  run_cmd_shell "echo 'deb [signed-by=/etc/apt/keyrings/google-cloud.gpg] https://packages.cloud.google.com/apt cloud-sdk main' | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list >/dev/null"
  run_cmd sudo apt -y update
  run_cmd sudo apt -y install google-cloud-cli
  run_cmd sudo apt -y install google-cloud-sdk-gke-gcloud-auth-plugin
}

cleanup_linux() {
  run_cmd sudo apt -y autoremove
}

linux_shell() {
  apt_update
  install_prereqs_linux
  install_oh_my_zsh_linux
}

linux_runtime() {
  install_node_linux
  install_postgres_linux
  create_dev_environment
  install_rbenv_linux
}

linux_editor() {
  install_vim_plugins
}

linux_git() {
  configure_git
}

linux_dotfiles() {
  configure_dotfiles_links
}

linux_extras() {
  install_gcloud_linux
  cleanup_linux
}
