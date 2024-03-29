set encoding=utf-8
set shell=sh
set shortmess+=I
set runtimepath+=$GOROOT/misc/vim
set backup
set backupdir=~/.cache/vim
set undofile
set undodir=~/.cache/vim
set ai smartindent
set hlsearch
set ignorecase
set smartcase
set showmatch
let c_space_errors=1

if !has('nvim')
	if v:version >= 704
		set cryptmethod=blowfish2
	else
		" unsecure, but Debian likes it
		set cryptmethod=blowfish
	endif
	set printoptions=paper:A4
	set printexpr=system('/usr/local/bin/lpr'\ .\ (&printdevice\ ==\ ''\ ?\ ''\ :\ '\ -P'\ .\ &printdevice)\ .\ '\ '\ .\ v:fname_in)\ .\ delete(v:fname_in)\ +\ v:shell_error
else
endif

set exrc
set secure

set vb
set modeline
set noshowmode
set noexpandtab
set shiftwidth=8
set tabstop=8
set t_Co=256
set mouse=

set wildmenu
set lazyredraw

set history=1000
set autoread

if exists('$DISPLAY')
	let &t_SI .= "\<Esc>[5 q"
	let &t_EI .= "\<Esc>[2 q"
endif

" Spelling support
set nospell spelllang=en_us,de
set spellfile=~/.vim/spell/spellfile.add

filetype plugin indent on
