function cn
  cd $argv
end

complete --command cn --exclusive --arguments '(__fish_complete_directories (~/Code/github.com/nateleavitt/))'
