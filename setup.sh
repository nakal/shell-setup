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
	ectags gnupg-2 gpgme mutt offlineimap procmail abook urlview lynx \
"
REQUIRED_PACKAGES_FreeBSD="\
	git tmux zsh \
	"
RECOMMENDED_PACKAGES_FreeBSD="\
	ctags gnupg neomutt offlineimap procmail abook urlview lynx fd-find \
	fzf py36-pip \
	"
REQUIRED_PACKAGES_Linux="\
	git vim zsh tmux \
	"
RECOMMENDED_PACKAGES_Linux="\
	exuberant-ctags gnupg2 neomutt offlineimap procmail abook urlview lynx
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

echo "-> Checking (neo)mutt..."
MUTT_IS_OK=1
mutt -v > /dev/null 2>&1
if [ $? -eq 0 ]; then
	mutt -v | grep -q '+CRYPT_BACKEND_GPGME'
	if [ $? -ne 0 ]; then
		MUTT_IS_OK=0
		echo "*** GPGME missing"
	fi
	mutt -v | egrep -q '(patch.*\.sidebar\.|USE_SIDEBAR)'
	if [ $? -ne 0 ]; then
		MUTT_IS_OK=0
		echo "*** SIDEBAR patch missing"
	fi
	mutt -v | grep -q '+HAVE_COLOR'
	if [ $? -ne 0 ]; then
		MUTT_IS_OK=0
		echo "*** Colors (NCURSES) missing"
	fi
else
	neomutt -v > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		neomutt -v | grep -q '+gpgme'
		if [ $? -ne 0 ]; then
			MUTT_IS_OK=0
			echo "*** GPGME missing"
		fi
		neomutt -v | grep -q '+color'
		if [ $? -ne 0 ]; then
			MUTT_IS_OK=0
			echo "*** Colors missing"
		fi
	else
		echo "*** mutt/neomutt not found, skipping checks."
		MUTT_IS_OK=0
	fi
fi
if [ $MUTT_IS_OK -ne 1 ]; then
	echo "*** WARNING: mutt/neomutt check failed."
else
	echo "-> (neo)mutt is ok, good."
fi

cd $HOME
REMOVE_FILES=".cshrc .tmux.conf .tmux.conf.sys .indent.pro \
	.gitignore_global .gitconfig .ctags \
	.git_template .clang-format \
	.zshrc .vim/vimrc .vim/mod .mailcap .urlview \
	.vim/colors/atom-dark-256.vim .vim/colors/atom-dark.vim \
	.vim/colors/onedark.vim .vim/autoload/onedark.vim \
	.local/bin/fzf .local/diff-highlight .config/nvim \
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
ln -s $SCRIPT_HOME/mutt/.mailcap .
ln -s $SCRIPT_HOME/mutt/.urlview .
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

echo "[shell-setup] Setting up mutt..."
mkdir -p $HOME/.mutt
touch $HOME/.mutt/.by-nakal
cd $HOME/.mutt
ln -s $SCRIPT_HOME/mutt/muttrc .
ln -s $SCRIPT_HOME/mutt/colors.muttrc .
ln -s $SCRIPT_HOME/mutt/edit_expires .
ln -s $SCRIPT_HOME/mutt/sync-notmuch .
ln -s $SCRIPT_HOME/mutt/gpg.rc .
ln -s $SCRIPT_HOME/mutt/mutt .

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

DIFFH=`which diff-highlight`;
if [ -z "$DIFFH" ]; then
	# OS specific setup
	cd $HOME/.local/bin
	case "$OS" in
		FreeBSD)
			ln -s /usr/local/share/git-core/contrib/diff-highlight/diff-highlight diff-highlight;
			ln -s /usr/share/examples/indent/indent.pro .indent.pro;
			;;
		Linux)
			test -d /usr/share/doc/git/contrib/diff-highlight && \
				ln -s /usr/share/doc/git/contrib/diff-highlight/diff-highlight diff-highlight;
			;;
		*)
			ln -s $SCRIPT_HOME/git/.diff-highlight.fallback diff-highlight;
			;;
	esac
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
