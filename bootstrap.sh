#!/bin/bash

function bootstrap() {

  case "$1" in
    no-rvm) rvm = "false" ;;
    no-brew) brew = "false" ;;
  esac

  case "$2" in
    no-rvm) rvm = "false" ;;
    no-brew) brew = "false" ;;
  esac


  function die() {
      echo "${@}"
      exit 1
  }

  function install_rvm() {
    echo "installing rvm stable"
    # bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
    bash -s stable < <(curl -sSL https://get.rvm.io)
  }

  function install_homebrew() {
    echo "installing Homebrew"
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
  }

  # move dotfiles
  echo 'moving dotfiles to hidden'
  mv $HOME/dotfiles ~/.dotfiles

  # Add <strong>.old</strong> to any existing Vim file in the home directory
  for i in $HOME/.vim $HOME/.vimrc $HOME/.gvimrc ~/.bashrc ~/.bash_profile; do
    if [[ ( -e $i ) || ( -h $i ) ]]; then
      echo "${i} has been renamed to ${i}.old"
      mv "${i}" "${i}.old" || die "Could not move ${i} to ${i}.old"
    fi
  done

  # Adding bash environment files
  echo "creating bash environment files"
  ln -s $HOME/.dotfiles/bash/bashrc $HOME/.bashrc
  ln -s $HOME/.dotfiles/bash/bash_profile $HOME/.bash_profile
  ln -s $HOME/.dotfiles/git/gitconfig $HOME/.gitconfig
  ln -s $HOME/.dotfiles/bash/git-completion.bash $HOME/.git-completion.bash

  echo "configuring ssh environment"
  mkdir $HOME/.ssh
  cp $HOME/.dotfiles/ssh/config.example $HOME/.dotfiles/ssh/config
  ln -s $HOME/.dotfiles/ssh/config $HOME/.ssh/config
  # ln -s $HOME/.dotfiles/janus $HOME/.janus

  if [ "$rvm" != "false" ]
  then
    install_rvm
  fi

  echo "source bash files - you may need to do it manually"
  source $HOME/.bashrc
  source $HOME/.bash_profile

  # Clone Janus into .vim
  #git clone https://github.com/carlhuda/janus.git $HOME/.vim \
  #  || die "Could not clone the repository to ${HOME}/.vim"

  # Run rake inside .vim
  #cd $HOME/.vim || die "Could not go into the ${HOME}/.vim"
  #rake || die "Rake failed."

  # Remove and replace .vimrc.before after files
  echo "replacing default gvimrc and vimrc files if installed"
  rm $HOME/.gvimrc.before $HOME/.gvimrc.after $HOME/.vimrc.before $HOME/.vimrc.after
  ln -s $HOME/.dotfiles/vim $HOME/.vim
  ln -s $HOME/.dotfiles/vim/gvimrc.before $HOME/.gvimrc.before
  ln -s $HOME/.dotfiles/vim/gvimrc.after $HOME/.gvimrc.after
  ln -s $HOME/.dotfiles/vim/vimrc.before $HOME/.vimrc.before
  ln -s $HOME/.dotfiles/vim/vimrc.after $HOME/.vimrc.after
  ln -s $HOME/.dotfiles/bin $HOME/bin

  if [ "$brew" != "false" ]
  then
    install_homebrew
  fi
}
