function ci
  cd $argv
end

complete --command ci --exclusive --arguments '(__fish_complete_directories (~/Code/github.com/infusionsoft/))'
