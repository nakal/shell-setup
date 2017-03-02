# Keyboard fixes

bindkey '\e[D' backward-char
bindkey '\e[C' forward-char
bindkey '\e\e[D' backward-word
bindkey '\e\e[C' forward-word
bindkey '\e[3~' delete-char
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[7~' beginning-of-line
bindkey '\e[8~' end-of-line
bindkey -M vicmd '\e[3~' delete-char
bindkey -M vicmd '\e[1~' beginning-of-line
bindkey -M vicmd '\e[4~' end-of-line
bindkey -M vicmd '\e[7~' beginning-of-line
bindkey -M vicmd '\e[8~' end-of-line
bindkey -M vicmd '\e[2~' vi-insert
bindkey '\e[2~' vi-cmd-mode

bindkey '^f' vi-forward-blank-word
bindkey '^b' vi-backward-blank-word

# CtrlP from zsh
zsh_ctrlp() {
	ctrlp_cmd="CtrlP $1"
	if [ -n "$DISPLAY" ] && [ -n "$DEFAULT_X_TERMINAL" ]; then
		(${DEFAULT_X_TERMINAL} -e vim -c "$ctrlp_cmd" 2>/dev/null) &
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
