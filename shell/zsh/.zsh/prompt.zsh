# Prompt settings

setopt promptsubst

if [ "$USER" = "root" ]; then
	export PS1='%F{red}%B%n@%m%b%f %F{34}%~%f %(?||%F{red}$(exit_code)%)%f )%# '
else
	export PS1='%F{yellow}%B%n@%m%b%f %F{34}%~%f %(?||%F{red}($(exit_code)%)%f )%# '
	export RPS1='$(git_status)'
fi

function exit_code() {
	CODE=$?
	case "$CODE" in
		129) echo "SIGHUP" ;;
		130) echo "SIGINT" ;;
		131) echo "SIGQUIT" ;;
		132) echo "SIGILL" ;;
		133) echo "SIGTRAP" ;;
		134) echo "SIGABRT" ;;
		135) echo "SIGEMT" ;;
		136) echo "SIGFPE" ;;
		137) echo "SIGKILL" ;;
		138) echo "SIGBUS" ;;
		139) echo "SIGSEGV" ;;
		140) echo "SIGSYS" ;;
		141) echo "SIGPIPE" ;;
		142) echo "SIGALRM" ;;
		143) echo "SIGTERM" ;;
		144) echo "SIGURG" ;;
		145) echo "SIGSTOP" ;;
		146) echo "SIGTSTP" ;;
		147) echo "SIGCONT" ;;
		148) echo "SIGCHLD" ;;
		149) echo "SIGTTIN" ;;
		150) echo "SIGTTOU" ;;
		151) echo "SIGIO" ;;
		152) echo "SIGXCPU" ;;
		153) echo "SIGXFSZ" ;;
		154) echo "SIGVTALRM" ;;
		155) echo "SIGPROF" ;;
		156) echo "SIGWINCH" ;;
		157) echo "SIGINFO" ;;
		158) echo "SIGUSR1" ;;
		159) echo "SIGUSR2" ;;
		160) echo "SIGTHR" ;;
		161) echo "SIGLIBRT" ;;
		*) echo "$CODE" ;;
	esac
}

function git_status() {
	LANG=C
	__git_status_slow_repo_size="2500"
	is_git_workdir=$(git rev-parse --is-inside-work-tree 2> /dev/null)
	if [ "$is_git_workdir" = "true" ]; then
		curgitpath=$(readlink -f $(git rev-parse --git-dir))
		ref=$(git symbolic-ref -q HEAD | sed  "s-refs/heads/--" | sed -e 's/^ *//' -e 's/ *$//')
		test -d "$curgitpath/rebase-apply" && rebasing="1"
		svnrepo=$(git config --local svn-remote.svn.url)

		if [ "$__git_status_last_git_path" != "$curgitpath" ]; then
			reposize=$(du -sk "$curgitpath/index" 2> /dev/null | sed 's/[^0-9].*//')
			if [ "$reposize" -lt "$__git_status_slow_repo_size" ]; then
				dirty=$(git status -s -uno --ignore-submodules=dirty 2> /dev/null | wc -l | sed -e 's/^ *//' -e 's/ *$//')
				uncommitted=$(git status -s --ignore-submodules=dirty 2> /dev/null | egrep "^\?\? " | wc -l | sed -e 's/^ *//' -e 's/ *$//')
				if [ -z "$svnrepo" ]; then
					unpushed=$(git status -sb --ignore-submodules=dirty 2> /dev/null | head -1 | grep '\[ahead ' | sed 's/.*\[ahead \([0-9][0-9]*\).*/\1/')
				else
					unpushed=""
				fi
				if [ "$dirty$uncommitted" != "00" ]; then
					if [ "$dirty" != "0" ]; then
						echo -n "%F{88}$dirty ($uncommitted)%f "
					else
						echo -n "%F{241}($uncommitted)%f "
					fi
				fi

				if [ "$dirty" != "0" ]; then
					echo -n "%F{white}%K{88}"
				else
					if [ "$unpushed" != "" ]; then
						echo -n "%F{28}-$unpushed %K{28}"
					else
						echo -n "%K{241}"
					fi
					echo -n "%F{white}"
				fi

				if [ "$rebasing" = "1" ]; then
					echo -n "%K{170}%F{white}"
					ref=$(basename $(cat "$curgitpath/rebase-apply/head-name"))
				fi
			else
				export __git_status_last_git_path="$curgitpath"
			fi
		fi

		if [ "$__git_status_last_git_path" = "$curgitpath" ]; then
			echo -n "%k%F{30}(skipped) %K{30}%F{white}"
		fi

		if [ -z "$ref" ]; then
			echo -n "%F{184}"
			ref="(???)"
		fi

		if [ -n "$svnrepo" ]; then
			ref="[svn] $ref"
		fi

		echo -n "$ref%f%k"
	fi
}
