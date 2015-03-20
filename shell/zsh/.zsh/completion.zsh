# Completion settings

autoload -U compinit
compinit

setopt nobeep
setopt completeinword

# cd ..<TAB> -> cd ../
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' verbose yes

# Colors
zmodload -i zsh/complist

# directories cyan, executables red, links purple
zstyle ':completion:*:default' list-colors 'di=36' 'ex=31' 'ln=35'
zstyle ':completion:*:(aliases|builtins|commands)' list-colors '=*=0;31'
zstyle ':completion:*:*:kill:*' list-colors '=(#b)(#s) #([0-9]##)* \(([^ ]##)\)*=0=31=33' '=(#b)(#s) #([0-9]##) ([^ ]##)*=0=31=33'
zstyle ':completion:*:(options|values)' list-colors '=(#b)(#s)(-*) -- *=1;0=31;1'

# Completion commands
zstyle ':completion:*:*:kill:*:processes' command 'ps -x -o pid= -o command='
zstyle ':completion:*:*:kill:*' ignored-patterns '(#s)0(#e)'
