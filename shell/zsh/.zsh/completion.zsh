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

# for commands
# candidates yellow
# optional emphasis red (e.g. kill process name)
zstyle ':completion:*:*:kill:*' list-colors '=(#b) #([0-9]##)* \(([^ ]##)\)*=0=33=31' '=(#b) #([0-9]##) ([^ ]##)*=0=33=31'
zstyle ':completion:*:(builtins|commands|options)' list-colors '=(#b)(-*) -- *=0=33' '=^(-- )*=33'
zstyle ':completion:*:aliases' list-colors '=*=33'
zstyle ':completion:*:*:git:*:aliases' list-colors '=(#b)* (-- *)=33=0'

# Completion commands
zstyle ':completion:*:*:kill:*:processes' command 'ps -x -o pid= -o command='
zstyle ':completion:*:*:kill:*' ignored-patterns '0'
