#!/bin/sh

# Repositories from github

ZSH_MODULES="tarruda/zsh-autosuggestions"
VIM_BUNDLES="\
	tpope/vim-fugitive \
	tpope/vim-unimpaired \
	bling/vim-airline \
	ctrlpvim/ctrlp.vim \
	"

# Git repo helper
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
	TMPD=../.tmp-active
	rm -rf "$TMPD"
	mkdir "$TMPD"
	for d in $@; do
		NAME=`basename "$d"`
		mv "$NAME" "$TMPD"
	done

	OLDDIRS=`find . -type d -maxdepth 1 -mindepth 1`
	echo "Removing (in $PWD): $OLDDIRS..."
	rm -rf .nakal-guard $OLDDIRS

	ACTDIRS=`find "$TMPD" -type d -maxdepth 1 -mindepth 1`
	for d in $ACTDIRS; do
		mv $d .
	done
	rmdir "$TMPD"

	for r in $@; do
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

OS=`uname -s`
if [ "$OS" != "Linux" ]; then
	MAKE_CMD=gmake
else
	MAKE_CMD=make
fi

if [ "$OS" = "FreeBSD" ]; then
	echo "[shell-setup] Checking required packages..."
	pkg info vim git tmux zsh the_silver_searcher > /dev/null
	if [ $? -ne 0 ]; then
		echo "ERROR: Missing packages for bootstrap (shell only)."
		exit 1
	fi
	echo "[shell-setup] Checking recommended packages..."
	pkg info ctags gnupg > /dev/null
	if [ $? -ne 0 ]; then
		echo "WARNING: Some recommended packages are not installed."
	fi
else
	echo "[shell-setup] WARNING: Skipped checking packages..."
fi

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
tmux -V | grep -q "tmux 2."
if [ "$OS" = "FreeBSD" ] && [ $? -ne 0 ]; then
	tmux -V | grep -q "tmux 1.9a"
	if [ $? -ne 0 ]; then
		echo "*** tmux version 2.x (at least 1.9a) is needed."
		exit 1
	fi
fi
echo "-> tmux is ok, good."

cd $HOME
REMOVE_FILES=".cshrc .tmux.conf .indent.pro \
	.gitignore_global .gitconfig .ctags \
	.zshrc .vim/autoload/pathogen.vim \
	.vim/vimrc \
	.vim/colors/atom-dark-256.vim .vim/colors/atom-dark.vim \
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
echo "Inspecting vim configuration..."
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

# prepare conf in user's home
echo "[shell-setup] Reinstalling softlinks..."
ln -s $SCRIPT_HOME/shell/tcsh/.cshrc .
ln -s $SCRIPT_HOME/tmux/.tmux.conf .
ln -s $SCRIPT_HOME/misc/.ctags .
ln -s $SCRIPT_HOME/git/.gitignore_global .
ln -s $SCRIPT_HOME/git/.gitconfig .
if [ "$OS" = "FreeBSD" ]; then
	ln -s /usr/share/examples/indent/indent.pro .
else
	echo "*** Skipping indent configuration..."
fi

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
cd $HOME
mkdir -p .vim/bundle .vim/autoload .vim/colors
touch $HOME/.vim/.by-nakal
cd .vim
ln -s $SCRIPT_HOME/vim/vimrc .

cd $HOME/.vim/autoload
VIM_PLUGIN_MANAGER="tpope/vim-pathogen"
git_update_repositories $VIM_PLUGIN_MANAGER
ln -s vim-pathogen/autoload/pathogen.vim .

cd ../bundle
git_update_repositories $VIM_BUNDLES

cd ../colors
VIM_COLORSCHEMES="gosukiwi/vim-atom-dark"
git_update_repositories $VIM_COLORSCHEMES
ln -s vim-atom-dark/colors/atom-dark.vim .
ln -s vim-atom-dark/colors/atom-dark-256.vim .

cd $HOME

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
