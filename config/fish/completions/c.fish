function c
  cd $argv
end

function cn
  cd $argv
end

function ci
  cd $argv
end

complete --command c --exclusive --arguments '(__fish_complete_directories (~/Code/))'
complete --command cn --exclusive --arguments '(__fish_complete_directories (~/Code/github.com/nateleavitt/))'
complete --command ci --exclusive --arguments '(__fish_complete_directories (~/Code/github.com/infusionsoft/))'

