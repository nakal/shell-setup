# zsh configuration

source ~/.zsh/env.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/sys.zsh
source ~/.zsh/kbd.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/history.zsh

if [ -f ~/.zshrc_local ]; then
	source ~/.zshrc_local
fi
