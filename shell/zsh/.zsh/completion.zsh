# Completion settings

autoload -U compinit
compinit

setopt nobeep

# cd ..<TAB> -> cd ../
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' verbose yes
