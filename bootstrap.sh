cd ~/
for i in ~/.vim ~/.vimrc ~/.gvimrc ~/.bashrc ~/.bash_profile; do [ -e $i ] && mv $i $i.old; done
bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
# git clone git://github.com/carlhuda/janus.git ~/.vim
ln -s ~/devenviro/vim/gvimrc ~/.gvimrc
ln -s ~/devenviro/vim/vimrc ~/.vimrc
ln -s ~/devenviro/bash/bashrc ~/.bashrc
ln -s ~/devenviro/bash/bash_profile ~/.bash_profile
ln -s ~/devenviro/git/gitconfig ~/.gitconfig
mkdir ~/.ssh
ln -s ~/devenviro/ssh/config ~/.ssh/config
source ~/.bashrc
source ~/.bash_profile
