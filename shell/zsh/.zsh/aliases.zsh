# Aliases

alias h='history -fdDE -25'

if which eza > /dev/null 2>&1; then
	alias ls='eza --git --color-scale -g'
	export EZA_COLORS='da=38;5;255:di=36:uu=1:gu=1'
elif which exa > /dev/null 2>&1; then
	alias ls='exa --git --color-scale -gl'
	export EXA_COLORS='da=38;5;255:di=36:uu=1:gu=1'
else
	case "$OS" in
		FreeBSD) alias ls='ls -G';;
		Linux)	alias ls='ls --color';;
		*)	alias ls='colorls -G';;
	esac
fi

if ! which fd > /dev/null 2>&1 && which fdfind > /dev/null 2>&1; then
	alias fd='fdfind'
fi

alias l='ls -l'
alias ..='cd ..'
alias ...='cd ../..'

if [ -n "$DEFAULT_X_TERMINAL" ] && [ -n "$DISPLAY" ]; then
	alias vi='background '${DEFAULT_X_TERMINAL}' -e '${EDITOR}
else
	alias vi=${EDITOR}
fi
alias vim=vi

function background()
{
	$@ &
}
