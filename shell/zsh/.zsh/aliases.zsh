# Aliases

alias h='history -fdDE -25'
alias ls='ls -G'
alias l='ls -l'
alias ..='cd ..'
alias ...='cd ../..'

if [ -n "$DISPLAY" ]; then
	alias vi='background '${DEFAULT_X_TERMINAL}' -e vim'
else
	alias vi='vim'
fi

function background()
{
	$@ &
}
