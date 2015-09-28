rbenv init - | source

set -x GOPATH $HOME/Code/go
set -g -x PATH $PATH $GOPATH/bin

# alias
function u; cd ..; end
function uu; cd ../..; end
function uuu; cd ../../..; end

function d; docker $argv; end
function dm; docker-machine $argv; end
