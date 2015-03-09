# History settings

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt histignoredups
setopt histignorespace
setopt appendhistory
setopt incappendhistory
setopt sharehistory
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '\eOA' up-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search
bindkey '\eOB' down-line-or-beginning-search
bindkey '\e[B' down-line-or-beginning-search

# Load autosuggestions module
source ~/.zsh/modules/zsh-autosuggestions/autosuggestions.zsh
AUTOSUGGESTION_HIGHLIGHT_COLOR='fg=240'

zle-line-init() {
	zle autosuggest-start
}

zle -N zle-line-init
bindkey '^T' autosuggest-toggle
bindkey '^f' vi-forward-blank-word
