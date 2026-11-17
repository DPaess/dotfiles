# eza is a modern ls with git integration (maintained fork of exa)
if which eza > /dev/null 2>&1; then
    alias ls="eza --git-ignore"
    alias ll="eza --git-ignore --git -l --group"
    alias la="eza --git -la"
else
    alias ls="ls --color=auto"
    alias ll="ls -l"
    alias la="ls -lA"
fi

# saving ls misswritings
for alias_name in lsl sls lsls sl l s; do
    alias $alias_name=ls
done

# grep stays grep (with color); use rg for fast recursive search. `cheat search` compares them.
alias grep="grep --color=auto"

# Open file with open
alias open="xdg-open"

# A really simple password generator
alias pw='bash -c '"'"'echo `tr -dc $([ $# -gt 1 ] && echo $2 || echo "A-Za-z0-9") < /dev/urandom | head -c $([ $# -gt 0 ] && echo $1 || echo 30)`'"'"' --'

# cat with syntax highlight
# Ubuntu ships bat as batcat
if command -v bat >/dev/null 2>&1; then
    alias cat="bat --style=plain"
elif command -v batcat >/dev/null 2>&1; then
    alias cat="batcat --style=plain"
fi

# Use neovim as vim
if command -v nvim >/dev/null 2>&1; then
    alias vim="nvim"
fi

# fd: Ubuntu ships it as fdfind; find stays find. `cheat search` compares them.
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    alias fd='fdfind'
fi

alias upgrade='sudo apt update && sudo apt upgrade'
alias aliases='vim ~/.bash_aliases'
alias bashrc='vim ~/.bashrc'
alias reload='source ~/.bashrc'

# cheat <topic>: short syntax notes from ~/.config/cheats; no topic lists them
cheat() {
    local dir="$HOME/.config/cheats"
    if [ -z "$1" ]; then
        ls "$dir" | sed 's/\.md$//'
        return
    fi
    local f="$dir/$1.md"
    [ -f "$f" ] || { echo "no cheat sheet: $1 (try: cheat)"; return 1; }
    if command -v batcat >/dev/null 2>&1; then batcat --style=plain --paging=never "$f"
    elif command -v bat >/dev/null 2>&1; then bat --style=plain --paging=never "$f"
    else command cat "$f"; fi
}
