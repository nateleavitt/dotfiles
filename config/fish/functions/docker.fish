function dm
  docker-machine $argv
end

function d
  docker $argv
end

function deval
  eval (docker-machine env $argv)
end
