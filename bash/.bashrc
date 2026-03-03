#################################
# Only run in interactive shells
#################################

case $- in
    *i*) ;;
      *) return;;
esac

###################
## PATH Handling ##
###################

# Function to safely prepend to PATH (avoid duplicates)
path_prepend() {
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.nvim/usr/bin"

export PATH

############################
## History Configuration  ##
############################

HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=200000

# Improve shell behavior: append history instead of overwriting, auto-adjust terminal size variables (LINES/COLUMNS), and enable recursive globbing with "**".
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

# Better history navigation with arrows
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Improve TAB behavior
bind "set show-all-if-ambiguous on"
bind 'TAB':menu-complete
bind "set menu-complete-display-prefix on"

# Sync history across terminals (great with tmux)
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

######################
## Prompt Custom    ##
######################

set_prompt() {
    local reset="\[\033[0m\]"
    local cyan="\[\033[38;5;14m\]"
    local green="\[\033[38;5;2m\]"
    local blue="\[\033[38;5;4m\]"
    local magenta="\[\033[38;5;13m\]"

    local venv='${VIRTUAL_ENV:+($(basename "$VIRTUAL_ENV")) }'

    if [ -n "$CONTAINER_ID" ]; then
        PS1="${cyan}[${venv}${green}\u@\h${magenta}.${CONTAINER_ID} ${blue}\W${cyan}]${reset}\\$ "
    else
        PS1="${cyan}[${venv}${green}\u@\h ${blue}\W${cyan}]${reset}\\$ "
    fi
}

PROMPT_COMMAND="set_prompt; $PROMPT_COMMAND"

#####################
## Color Settings  ##
#####################

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export COLORTERM=truecolor

#########################
## Editor Configuration ##
#########################

if command -v nvim >/dev/null 2>&1; then
    export EDITOR="nvim"
    export VISUAL="nvim"
    export MANPAGER="nvim --clean +Man!"
    export MANWIDTH=999
fi

#########################
## Modern Integrations ##
#########################

# zoxide (smart cd)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init --cmd cd bash)"
fi

# fzf (Ctrl+R, file search)
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"
fi

# difftastic as git diff tool (optional)
if command -v difft >/dev/null 2>&1; then
    export GIT_EXTERNAL_DIFF=difft
fi

##########################
## Source Extra Configs ##
##########################

[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.localrc ] && . ~/.localrc
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
