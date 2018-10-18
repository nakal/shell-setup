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

# FZF from zsh
zsh_fzf() {
	fzf_dir="$1"
	if test -z "$fzf_dir"; then
		fzf_dir="g:shs_project_dir"
	else
		fzf_dir="\"$fzf_dir\""
	fi
	fzf_cmd="call FZFTryGFiles($fzf_dir)"
	if [ -n "$DISPLAY" ] && [ -n "$DEFAULT_X_TERMINAL" ]; then
		(${DEFAULT_X_TERMINAL} -e vim -c "$fzf_cmd" 2>/dev/null) &
	else
		</dev/tty vim -c "$fzf_cmd"
	fi
}

zsh_fzf_curdir() {
	zsh_fzf .
}

zle -N zsh_fzf
zle -N zsh_fzf_curdir

bindkey "^p" zsh_fzf

if [ -n "$TMUX" ]; then
	bindkey "OD" zsh_fzf
	bindkey "OC" zsh_fzf_curdir
else
	bindkey "Od" zsh_fzf
	bindkey "Oc" zsh_fzf_curdir
fi

fzfpath="/usr/local/share/examples/fzf/shell"
if which fd > /dev/null; then
	FZF_CTRL_T_COMMAND="fd"
	FZF_ALT_C_COMMAND="fd -H -t d"
fi
if [ -e "$fzfpath/key-bindings.zsh" ]; then
	. $fzfpath/key-bindings.zsh
fi
