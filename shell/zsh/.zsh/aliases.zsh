# Aliases

alias h='history -fdDE -25'

if [ "$OS" = "FreeBSD" ]; then
	alias ls='ls -G'
else
	alias ls='colorls -G'
fi
alias l='ls -l'
alias ..='cd ..'
alias ...='cd ../..'

if [ -n "$DEFAULT_X_TERMINAL" ] && [ -n "$DISPLAY" ]; then
	alias vi='background '${DEFAULT_X_TERMINAL}' -e vim'
else
	alias vi='vim'
fi

function background()
{
	$@ &
}
