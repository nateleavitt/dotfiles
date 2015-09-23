function c
  cd $argv
end

complete --command c --exclusive --arguments '(__fish_complete_directories (~/Code/))'

