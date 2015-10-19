rbenv init - | source

set -x GOPATH $HOME/Code/go
set -g -x PATH $PATH $GOPATH/bin

# alias
function u; cd ..; end
function uu; cd ../..; end
function uuu; cd ../../..; end

function d; docker $argv; end
function dm; docker-machine $argv; end
function c; cd $argv; end
function t; terraform $argv; end

function deval
  eval (docker-machine env $argv)
end

function ci
  if count $argv > /dev/null; cd $argv; else; cd ~/Code/github.com/infusionsoft/; end
end

function cn
  if count $argv > /dev/null; cd $argv; else; cd ~/Code/github.com/nateleavitt/; end
end

function cg
  if count $argv > /dev/null; cd $argv; else; cd ~/Code/go/src/github.com/; end
end

