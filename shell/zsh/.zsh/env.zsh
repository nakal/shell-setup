# Environment settings

export EDITOR='vim'
export PAGER='less'
export BLOCKSIZE='K'
export LSCOLORS='gxfxcxdxbxegedabagacad'
export GOROOT='/usr/local/go'

if [ -n "$DISPLAY" ]; then
	for termtype in xterm urxvt; do
		which -s $termtype > /dev/null
		if [ $? -eq 0 ] && [ -z "$DEFAULT_X_TERMINAL" ]; then
			export DEFAULT_X_TERMINAL="$termtype"
		fi
	done
fi

# Nice features for less
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_so=$'\E[38;5;016m\E[48;5;220m'    # begin standout-mode - info box
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

source ~/.zsh/path.zsh

if [ -z "$TMUX" ]; then
	export TERM='xterm-256color'
else
	export TERM='screen-256color'
fi
