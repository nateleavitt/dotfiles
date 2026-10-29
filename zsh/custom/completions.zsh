DEV_ROOT="${DEV_ROOT:-$HOME/code}"

# c <repo>: jump to ~/code/<repo> (tab-completes). Bare `c` picks a repo with fzf.
c() {
  if [[ -n "$1" ]]; then
    cd "${DEV_ROOT}/$1"
  elif command -v fzf >/dev/null 2>&1; then
    local dir
    dir="$(cd "${DEV_ROOT}" && print -l *(N/) | fzf --height 40% --reverse)" || return
    cd "${DEV_ROOT}/${dir}"
  else
    cd "${DEV_ROOT}"
  fi
}
compctl -W "${DEV_ROOT}/" -/ c
