rbenv init - | source

set -x PATH $PATH /home/nate/.rbenv/bin
# alias
function u; cd ..; end
function uu; cd ../..; end
function uuu; cd ../../..; end
function typora; open -a typora $argv; end

function d; docker $argv; end
# function dm; docker-machine $argv; end
function c; cd $argv; end

function dco; docker-compose $argv; end
function dm; docker-machine $argv; end
function dco-be; docker-compose exec web bundle exec $argv; end

# function deval
#   eval (docker-machine env $argv)
# end

