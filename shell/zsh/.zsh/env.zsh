# Environment settings

export PAGER='less'
export BLOCKSIZE='K'
export LSCOLORS='gxfxcxdxbxegedabagacad'
export EXA_COLORS='di=36:da=0:uu=1:gu=1'
export GOROOT='/usr/local/go'

source ~/.zsh/path.zsh

if which -s nvim > /dev/null; then
	export EDITOR='nvim'
else
	export EDITOR='vim'
fi

if [ -n "$DISPLAY" ]; then
	for termtype in xterm urxvt; do
		which -s $termtype > /dev/null
		if [ $? -eq 0 ] && [ -z "$DEFAULT_X_TERMINAL" ]; then
			export DEFAULT_X_TERMINAL="$termtype"
		fi
	done
	if [ "$DEFAULT_X_TERMINAL" = "urxvt" ]; then
		TERM="rxvt-unicode-256color"
	fi
	if [ "$DEFAULT_X_TERMINAL" = "xterm" ]; then
		TERM="xterm-256color"
	fi
	export TERM
fi

# Nice features for less
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_so=$'\E[38;5;016m\E[48;5;220m'    # begin standout-mode - info box
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
if [ "$OS" = "OpenBSD" ];then
	export LESS="-cR"
fi

# GPG agent
GPG_TTY=$(tty)
export GPG_TTY
