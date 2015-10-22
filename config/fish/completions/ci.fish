function ci
  if count $argv > /dev/null; cd $argv; else; cd ~/Code/github.com/infusionsoft/; end
end

complete --command ci --exclusive --arguments "(__fish_complete_directories (~/Code/github.com/infusionsoft/))"
