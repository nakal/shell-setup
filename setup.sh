#!/bin/sh

# Repositories from github

ZSH_MODULES=""
VIM_PLUGINS="\
	tpope/vim-fugitive \
	tpope/vim-unimpaired \
	tpope/vim-surround \
	bling/vim-airline \
	airblade/vim-gitgutter \
	junegunn/fzf \
	junegunn/fzf.vim \
	sheerun/vim-polyglot \
	w0rp/ale \
	Shougo/deoplete.nvim \
	"

# Git repo helper (clone or update a repository)
git_init_dir()
{
	REPOPATH="$1"
	REPODIR="$2"
	if [ -d "$REPODIR" ]; then
		OLDDIR=`pwd`
		cd "$REPODIR"
		git pull
		cd "$OLDDIR"
	else
		git clone "$REPOPATH" "$REPODIR"
	fi
}

git_update_repositories()
{
	# Save repositories that we still need
	TMPD=../.tmp-active
	rm -rf "$TMPD"
	mkdir "$TMPD"
	for d in "$@"; do
		NAME=`basename "$d"`
		mv "$NAME" "$TMPD"
	done

	# Remove repositories that we don't need anymore
	OLDDIRS=`find . -maxdepth 1 -mindepth 1 -type d`
	echo "Removing (in $PWD): $OLDDIRS..."
	rm -rf .nakal-guard $OLDDIRS

	# Move back repositories to update them in place
	ACTDIRS=`find "$TMPD" -maxdepth 1 -mindepth 1 -type d`
	for d in $ACTDIRS; do
		mv $d .
	done
	rmdir "$TMPD"

	for r in "$@"; do
		NAME=`basename "$r"`
		git_init_dir "https://github.com/$r" "$NAME"
	done
}

tidy_up_dot_directory()
{
	NAME="$1"
	echo "Inspecting $NAME configuration..."
	if [ -d "$HOME/.$NAME" ]; then
		if [ -f "$HOME/.$NAME/.by-nakal" ]; then
			echo "It's my own $NAME configuration. Removing softlinks..."
			rm -f `find "$HOME/.$NAME" -maxdepth 1 -mindepth 1 -type l`
		else
			echo "ERROR: directory "$HOME/.$NAME" is not familiar to me."
			echo "Please move it away to a safe location!"
			exit 1
		fi
	else
		if [ -e "$HOME/.$NAME" ]; then
			echo "Cannot install in $HOME/.$NAME!"
			exit 1
		fi
	fi
}

echo "[shell-setup] Looking for my installation directory..."
SCRIPT_HOME=`dirname $0`
SCRIPT_HOME=`readlink -f "$SCRIPT_HOME"`
if [ -x "$SCRIPT_HOME/setup.sh" ]; then
	echo "Found myself in $SCRIPT_HOME, good."
else
	echo "Hmm, I cannot find my own directory. Giving up..."
	exit 1
fi

# Add local binary directory
cd $HOME
mkdir -p .local/bin

OS=`uname -s`
REQUIRED_PACKAGES_OpenBSD="\
	git vim zsh ripgrep colorls \
	"
RECOMMENDED_PACKAGES_OpenBSD="\
	ectags gnupg-2 gpgme lynx \
"
REQUIRED_PACKAGES_FreeBSD="\
	git tmux zsh \
	"
RECOMMENDED_PACKAGES_FreeBSD="\
	ctags gnupg lynx fd-find \
	fzf py39-pip \
	"
REQUIRED_PACKAGES_Linux="\
	git neovim zsh tmux \
	"
RECOMMENDED_PACKAGES_Linux="\
	exuberant-ctags gnupg2 \
	lynx python3-pip fzf ripgrep fd-find \
	"
. "$SCRIPT_HOME/include/packages.sh"
check_packages

echo "[shell-setup] Checking software capabilities..."
echo "-> Checking git..."
git version | grep -q "git version 2"
if [ $? -ne 0 ]; then
	echo "*** git version 2.x.y is needed."
	exit 1
else
	echo "-> git is ok, good."
fi
echo "-> Checking tmux..."
which tmux
if [ $? -ne 0 ]; then
	echo "*** tmux version 2.x is needed."
	exit 1
fi
echo "-> tmux is ok, good."

cd $HOME
REMOVE_FILES=".cshrc .tmux.conf .tmux.conf.sys .indent.pro \
	.gitignore_global .gitconfig .ctags \
	.git_template .clang-format \
	.zshrc .vim/vimrc .vim/mod .mailcap .urlview \
	.vim/colors/atom-dark-256.vim .vim/colors/atom-dark.vim \
	.vim/colors/onedark.vim .vim/autoload/onedark.vim \
	.local/bin/fzf .local/bin/diff-highlight .config/nvim \
	"

for df in $REMOVE_FILES; do
	echo Checking dotfile: $df
	test -e $df && test ! -L $df && \
		echo "*** It is not a soft-link. Please move it to a safe location!" && exit 1
done

# remove old stuff
cd $HOME
echo "[shell-setup] Removing old softlinks..."
rm -f $REMOVE_FILES

# tidy up vim
echo "Inspecting (neo)vim configuration..."
if [ -d $HOME/.vim ]; then
	if [ -f $HOME/.vim/.by-nakal ]; then
		echo "It's my own vim configuration. Keeping..."
	else
		echo "ERROR: directory $HOME/.vim is not familiar to me."
		echo "Please move it away to a safe location!"
		exit 1
	fi
else
	if [ -e $HOME/.vim ]; then
		echo "Cannot install in $HOME/.vim!"
		exit 1
	fi
fi

# tidy up zsh
tidy_up_dot_directory zsh

# tidy up mutt
tidy_up_dot_directory mutt

# prepare conf in user's home
echo "[shell-setup] Reinstalling softlinks..."
ln -s $SCRIPT_HOME/shell/tcsh/.cshrc .
ln -s $SCRIPT_HOME/tmux/.tmux.conf .
ln -s $SCRIPT_HOME/git/.gitignore_global .
ln -s $SCRIPT_HOME/git/.gitconfig .
ln -s $SCRIPT_HOME/git/template .git_template
ln -s $SCRIPT_HOME/misc/.clang-format .

echo Checking local tmux configuration...
if [ -r "$HOME/.tmux.local" ]; then
	echo "Already exists (skipping)."
else
	grep "set -g status-style " "$HOME/.tmux.conf" | sed 's/^/#/' > "$HOME/.tmux.local"
	echo "-> Installed. You can change tmux status bar color in $HOME/.tmux.local."
fi

echo "[shell-setup] Preparing zsh..."
mkdir -p $HOME/.zsh/modules
touch $HOME/.zsh/.by-nakal
ln -s $SCRIPT_HOME/shell/zsh/.zshrc .
cd $HOME/.zsh
ln -s $SCRIPT_HOME/shell/zsh/.zsh/*.zsh .
cd modules
git_update_repositories $ZSH_MODULES

echo "[shell-setup] Preparing vim and plugins..."
mkdir -p $HOME/.vim
cd $HOME/.vim
rm -rf plugins autoload colors
mkdir -p pack/vim/start pack/vim/opt colors autoload/airline/themes themes
touch .by-nakal
test -d $HOME/.cache/vim || mkdir -p $HOME/.cache/vim
ln -s $SCRIPT_HOME/vim/vimrc .
ln -s $SCRIPT_HOME/vim/mod .
mkdir -p $HOME/.config
cd $HOME/.config
ln -s $SCRIPT_HOME/vim nvim

cd $HOME/.vim/pack/vim/start
git_update_repositories $VIM_PLUGINS

cd $HOME/.vim/themes
VIM_COLORSCHEMES="joshdick/onedark.vim"
git_update_repositories $VIM_COLORSCHEMES
cd $HOME/.vim/colors
ln -s ../themes/onedark.vim/colors/onedark.vim .
cd $HOME/.vim/autoload
ln -s ../themes/onedark.vim/autoload/onedark.vim .
cd airline/themes
ln -s ../../../themes/onedark.vim/autoload/airline/themes/onedark.vim .

cd $HOME/.vim/pack
case $EDITOR in
	nvim) vimopt='-es';;
	vim) vimopt='-T dumb';;
	*) vimopt='';;
esac
if [ -n "$vimopt" ]; then
	for docdir in `ls -d vim/*/*/doc`; do
		"$EDITOR" -u NONE -c "helptags $docdir" -c q $vimopt
	done
fi

if [ "$OS" = "Linux" ]; then
	echo "[shell-setup] Installing fzf..."
	yes | $HOME/.vim/pack/vim/start/fzf/install
	cd $HOME/.local/bin
	ln -s ../../.vim/pack/vim/start/fzf/bin/fzf .
fi

cd $HOME

echo "[shell-setup] Checking for diff-highlight..."
DIFFH=`which diff-highlight`;
if [ -z "$DIFFH" ]; then
	# OS specific setup
	echo "Need to install a linked script."
	cd $HOME/.local/bin
	case "$OS" in
		FreeBSD)
			ln -s /usr/local/share/git-core/contrib/diff-highlight/diff-highlight diff-highlight;
			ln -s /usr/share/examples/indent/indent.pro .indent.pro;
			;;
		Linux)
			if [ -x /usr/share/doc/git/contrib/diff-highlight/diff-highlight ]; then
				ln -s /usr/share/doc/git/contrib/diff-highlight/diff-highlight diff-highlight;
			else
				echo "Warning: diff-highlight from git contribution package is not available."
				if [ -r /usr/share/doc/git/contrib/diff-highlight/diff-highlight.perl ]; then
					echo "	Fix it! Change into the directory"
					echo "  /usr/share/doc/git/contrib/diff-highlight"
					echo "  and run \"make\"."
					exit 1
				else
					echo "  Linking diff-highlight fallback script."
					ln -s $SCRIPT_HOME/git/.diff-highlight.fallback diff-highlight;
				fi
			fi
			;;
		*)
			echo "Unknown system, linking diff-highlight fallback script."
			ln -s $SCRIPT_HOME/git/.diff-highlight.fallback diff-highlight;
			;;
	esac
else
	echo "Skipping, is installed natively."
fi

if [ "$OS" = "FreeBSD" ] && [ ! -r /usr/share/syscons/keymaps/us.capsescswap.kbd ]; then
	echo "Warning: syscons keymap with swapped ESC and CAPSLOCK"
	echo "         has not been installed, yet."
	echo "1) Copy the file:"
	echo "         cp ./syscons/us.capsescswap.kbd /usr/share/syscons/keymaps/"
	echo "2) Set in /etc/rc.conf:"
	echo "         keymap=\"us.capsescswap.kbd\""
fi

echo "[shell-setup] Finished successfully."

exit 0
