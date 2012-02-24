function die()
{
    echo "${@}"
    exit 1
}

# Add <strong>.old</strong> to any existing Vim file in the home directory
for i in $HOME/.vim $HOME/.vimrc $HOME/.gvimrc ~/.bashrc ~/.bash_profile; do
  if [[ ( -e $i ) || ( -h $i ) ]]; then
    echo "${i} has been renamed to ${i}.old"
    mv "${i}" "${i}.old" || die "Could not move ${i} to ${i}.old"
  fi
done

# Adding bash environment files
echo "creating bash environment files"
ln -s $HOME/devenviro/bash/bashrc $HOME/.bashrc
ln -s $HOME/devenviro/bash/bash_profile $HOME/.bash_profile
ln -s $HOME/devenviro/git/gitconfig $HOME/.gitconfig

echo "configuring ssh environment"
mkdir $HOME/.ssh
ln -s $HOME/devenviro/ssh/config $HOME/.ssh/config

echo "installing rvm"
bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)

echo "source bash files - you may need to do it manually"
source $HOME/.bashrc
source $HOME/.bash_profile

# Clone Janus into .vim
git clone https://github.com/carlhuda/janus.git $HOME/.vim \
  || die "Could not clone the repository to ${HOME}/.vim"

# Run rake inside .vim
cd $HOME/.vim || die "Could not go into the ${HOME}/.vim"
rake || die "Rake failed."

