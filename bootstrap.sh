for i in ~/.vim ~/.vimrc ~/.gvimrc ~/.bashrc ~/.bash_profile; do [ -e $i ] && mv $i $i.old; done
# git clone git://github.com/carlhuda/janus.git ~/.vim
ln -s ~/devenviro/vim/gvimrc ~/.gvimrc
ln -s ~/devenviro/vim/vimrc ~/.vimrc
ln -s ~/devenviro/bash/bashrc ~/.bashrc
ln -s ~/devenviro/bash/bash_profile ~/.bash_profile
ln -s ~/devenviro/git/gitconfig ~/.gitconfig
