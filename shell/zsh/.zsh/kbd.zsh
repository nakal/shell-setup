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
	(unset TMUX; ${DEFAULT_X_TERMINAL} -e tmux -2 new-session 'vim -c CtrlP' 2>/dev/null) &
}
zle -N zsh_ctrlp

bindkey "^p" zsh_ctrlp
