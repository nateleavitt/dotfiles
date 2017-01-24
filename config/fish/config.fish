rbenv init - | source

set -x GOPATH $HOME/Code/go
set -g -x PATH $PATH $GOPATH/bin

# alias
function u; cd ..; end
function uu; cd ../..; end
function uuu; cd ../../..; end
function typora; open -a typora $argv; end

function d; docker $argv; end
# function dm; docker-machine $argv; end
function c; cd $argv; end
function t; terraform $argv; end

function dcr; docker-compose run $argv; end
function dcu; docker-compose up; end
function dcd; docker-compose down; end
function dcb; docker-compose build; end

# function deval
#   eval (docker-machine env $argv)
# end

# alias d docker
