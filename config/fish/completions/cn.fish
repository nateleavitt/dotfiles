function cn
  if count $argv > /dev/null; cd $argv; else; cd ~/Code/github.com/nateleavitt/; end
end

complete --command cn --exclusive --arguments "(__fish_complete_directories (~/Code/github.com/nateleavitt/))"
