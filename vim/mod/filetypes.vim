" setup filetypes
augroup setup_filetypes
	autocmd!
	autocmd FileType c		:call C_Setup()
	autocmd FileType cpp		:call Cpp_Setup()
	autocmd FileType haskell	:call Haskell_Setup()
	autocmd FileType cabal		:call Haskell_Setup()
	autocmd FileType php		:call PHP_Setup()
	autocmd FileType tex		:call LaTeX_Setup()
	autocmd FileType mail		:call Mail_Setup()
	autocmd FileType make		:call Makefile_Setup()
	autocmd FileType sh		:call Script_Setup()
	autocmd FileType gitcommit	:call GitCommit_Setup()
	autocmd FileType cmake		:call CMake_Setup()
	autocmd FileType yaml		:call Yaml_Setup()
	autocmd FileType closure	:call Closure_Setup()
augroup end

" ** GENERAL functions **
function! TermWidthWarning()
	highlight ColorColumn ctermbg=darkred ctermfg=white guibg=darkred guifg=white
	call matchadd('ColorColumn', '\%81v', 100)
endfunction

function! ASCII_Only_File()
	highlight NonASCII ctermbg=yellow guibg=yellow
	call matchadd('NonASCII', "[\x7f-\xff]", -1)
endfunction

function! SetupFolds()
	setlocal nofoldenable
	setlocal foldmethod=syntax
	setlocal foldnestmax=1
endfunction

" ** C **
function! C_Setup()
	call FreeBSD_Style()
	call TermWidthWarning()
	call ASCII_Only_File()
	call SetupFolds()
	nnoremap <silent> <leader>i :call Indent_C()<CR>
	highlight ExtraWhitespace ctermbg=darkred ctermfg=darkred guibg=darkred guifg=darkred
	call matchadd('ExtraWhitespace', '\s\+$\| \+\ze\t', 100)
endfunction

" Follow the FreeBSD style(9).
function! FreeBSD_Style()
	setlocal fileformat=unix
	setlocal cindent
	setlocal cinoptions=(4200,u4200,+0.5s,*500,:0,t0,U4200,g0,N-s,E-s,i4
	setlocal indentexpr=IgnoreParenIndent()
	setlocal indentkeys=0{,0},0),:,0#,!^F,o,O,e
	setlocal textwidth=80
endfun

" indent buffer
function! Indent_C()
	let oldformat = &fileformat
	set fileformat=unix
	silent exec ":%!indent"
	silent exec ":%s/\\s*$//"
	silent normal ggVG=gg
	let &fileformat=oldformat
endfun

" Ignore indents caused by parentheses in FreeBSD style.
function! IgnoreParenIndent()
    let indent = cindent(v:lnum)

    if indent > 4000
        if cindent(v:lnum - 1) > 4000
		return indent(v:lnum - 1)
        else
		return indent(v:lnum - 1) + 4
        endif
    else
        return (indent)
    endif
endfun

" ** C++ **
function! Cpp_Setup()
	call FreeBSD_Style()
	call TermWidthWarning()
	call ASCII_Only_File()
	call SetupFolds()
	nnoremap <silent> <leader>i :call Indent_Cpp()<CR>
	highlight ExtraWhitespace ctermbg=darkred ctermfg=darkred guibg=darkred guifg=darkred
	call matchadd('ExtraWhitespace', '^\t\+         \+\|\s\+$\| \+\ze\t', 100)
endfunction

" indent buffer
function! Indent_Cpp()
	let oldformat = &fileformat
	setlocal fileformat=unix
	silent exec ":%!" . GetFirstExecutable("clang-format", "clang-format90", "clang-format80") . " -style=file"
	let &fileformat=oldformat
endfun

" ** Haskell **

function! Haskell_Setup()
	setlocal tabstop=8
	setlocal expandtab
	setlocal softtabstop=8
	setlocal shiftwidth=8
	setlocal shiftround
	call SetupFolds()
	highlight ExtraWhitespace ctermbg=darkred ctermfg=darkred guibg=darkred guifg=darkred
	call matchadd('ExtraWhitespace', '^ *\t\+ *\|\s\+$\| \+\ze\t', 100)
	call ASCII_Only_File()
endfunction

" ** PHP **

function! PHP_Setup()
	setlocal tabstop=2
	setlocal expandtab
	setlocal softtabstop=0
	setlocal shiftwidth=2
	setlocal shiftround
	call SetupFolds()
	call TermWidthWarning()
	highlight ExtraWhitespace ctermbg=darkred ctermfg=darkred guibg=darkred guifg=darkred
	call matchadd('ExtraWhitespace', '^ *\t\+ *\|\s\+$\| \+\ze\t', 100)
	call ASCII_Only_File()
endfunction

" ** LaTeX **

function! LaTeX_Setup()
	setlocal spell
	call SetupFolds()
	highlight ExtraWhitespace ctermbg=darkred ctermfg=darkred guibg=darkred guifg=darkred
	call matchadd('ExtraWhitespace', '\s\+$', 100)
endfunction

" ** Emails **

function! Mail_Setup()
	setlocal spell
	call TermWidthWarning()
endfunction

" ** Makefiles **

function! Makefile_Setup()
	call ASCII_Only_File()
	call TermWidthWarning()
	highlight ExtraWhitespace ctermbg=darkred ctermfg=darkred guibg=darkred guifg=darkred
	call matchadd('ExtraWhitespace', '^     \+\|^\t\+         \+\|\s\+$\| \+\ze\t', 100)
endfunction

" ** CMake **

function! CMake_Setup()
	call ASCII_Only_File()
	highlight ExtraWhitespace ctermbg=darkred ctermfg=darkred guibg=darkred guifg=darkred
	call matchadd('ExtraWhitespace', '^     \+\|^\t\+         \+\|\s\+$\| \+\ze\t', 100)
endfunction

" ** Script files **

function! Script_Setup()
	call ASCII_Only_File()
	call TermWidthWarning()
	highlight ExtraWhitespace ctermbg=darkred ctermfg=darkred guibg=darkred guifg=darkred
	call matchadd('ExtraWhitespace', '^     \+\|^\t\+         \+\|\s\+$\| \+\ze\t', 100)
endfunction

" ** Git commits **

function! GitCommit_Setup()
	setlocal spell
	call TermWidthWarning()
	call ASCII_Only_File()
	highlight ExtraWhitespace ctermbg=darkred ctermfg=darkred guibg=darkred guifg=darkred
	call matchadd('ExtraWhitespace', '^     \+\|^\t\+         \+\|\s\+$\| \+\ze\t', 100)
endfunction

" ** Yaml **

function! Yaml_Setup()
	highlight ExtraWhitespace ctermbg=darkred ctermfg=darkred guibg=darkred guifg=darkred
	call matchadd('ExtraWhitespace', '^\s*\t\+\s*\|\s\+\ze$', 100)
	setlocal shiftwidth=2
	setlocal tabstop=2
	setlocal expandtab
endfunction

" ** Closure **

function! Closure_Setup()
	highlight ExtraWhitespace ctermbg=darkred ctermfg=darkred guibg=darkred guifg=darkred
	call matchadd('ExtraWhitespace', '\s\+$\| \+\ze\t', 100)
	setlocal shiftwidth=2
	setlocal tabstop=2
	setlocal expandtab
endfunction
