# zsh configuration

OS=`uname -s`

source ~/.zsh/env.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/sys.zsh
source ~/.zsh/kbd.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/history.zsh

[ -f ~/.zshrc_local ] && source ~/.zshrc_local

true
