# Keyboard fixes

bindkey '\e[D' backward-char
bindkey '\e[C' forward-char
bindkey '\e\e[D' backward-word
bindkey '\e\e[C' forward-word
bindkey '\e[3~' delete-char
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

# CtrlP from zsh
zsh_ctrlp() {
	ctrlp_cmd="CtrlP $1"
	if [ -n "$DISPLAY" ] && [ -n "$DEFAULT_X_TERMINAL" ]; then
		(unset TMUX; ${DEFAULT_X_TERMINAL} -e tmux -2 new-session "vim -c \"$ctrlp_cmd\"" 2>/dev/null) &
	else
		</dev/tty vim -c "$ctrlp_cmd"
	fi
}

zsh_ctrlp_curdir() {
	zsh_ctrlp .
}

zle -N zsh_ctrlp
zle -N zsh_ctrlp_curdir

bindkey "^p" zsh_ctrlp
bindkey "OD" zsh_ctrlp
bindkey "OC" zsh_ctrlp_curdir
