# Environment settings

export EDITOR='vim'
export PAGER='less'
export BLOCKSIZE='K'
export LSCOLORS='gxfxcxdxbxegedabagacad'
export GOROOT='/usr/local/go'

source ~/.zsh/path.zsh

if [ -z "$TMUX" ]; then
	export TERM='xterm-256color'
else
	export TERM='screen-256color'
fi
