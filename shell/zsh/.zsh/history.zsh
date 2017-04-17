# History settings

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt histignoredups
setopt histexpiredupsfirst
setopt appendhistory
setopt incappendhistory
setopt sharehistory
setopt extendedhistory
setopt nobanghist
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '\eOA' up-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search
bindkey '\eOB' down-line-or-beginning-search
bindkey '\e[B' down-line-or-beginning-search
