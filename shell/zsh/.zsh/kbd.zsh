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
	local is_git_workdir=$(git rev-parse --is-inside-work-tree 2> /dev/null)
	local sources="file_rec/async"
	if [ "$is_git_workdir" = "true" ]; then
		sources="file_rec/git"
	fi
	(unset TMUX; xterm -e tmux -2 new-session "vim -c 'Unite -toggle -start-insert $sources'" 2>/dev/null) &
}
zle -N zsh_ctrlp

bindkey "^p" zsh_ctrlp
