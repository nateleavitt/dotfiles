function cg
  if count $argv > /dev/null; cd $argv; else; cd ~/Code/go/src/github.com/; end
end

complete --command cg --exclusive --arguments "(__fish_complete_directories (~/Code/go/src/github.com))"
