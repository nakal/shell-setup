" Fix home/end key bindings
" nnoremap <silent> <Esc>[7~ ^
" nnoremap <silent> <Esc>[8~ $
" inoremap <silent> <Esc>[7~ <Esc>^i
" inoremap <silent> <Esc>[8~ <Esc>$a

let g:ctrlp_map = '<leader>p'
let g:ctrlp_regexp = 1
"let g:ctrlp_custom_ignore = {
" \ 'dir': '\v[\/]\.(git|hg|svn)$|\v[\/](tmp|bak|old|build.*|html)$',
" \ 'file': '\v\.(exe|so|dll|zip|o|a|obj|swp|hi|core|xls|doc|pdf|png|aux|idx|
"      	\ilg|ind|lof|lot|toc)$',
" \ }
if executable('rg')
	" ripgrep
	let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
	let g:ctrlp_use_caching = 0
elseif executable('ag')
	" the silver searcher
	let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
	\ --ignore ".git"
	\ --ignore ".svn"
	\ --ignore ".hg"
	\ --ignore ".*"
	\ --ignore "*.exe"
	\ --ignore "*.dll"
	\ --ignore "*.so"
	\ --ignore "*.[ao]"
	\ --ignore "*.obj"
	\ --ignore "*.zip"
	\ --ignore "*.sw[p-z]"
	\ --ignore "*.hi"
	\ --ignore "*.core"
	\ --ignore "*.xls"
	\ --ignore "*.doc"
	\ --ignore "*.pdf"
	\ --ignore "*.png"
	\ --ignore "*.aux"
	\ --ignore "*.idx"
	\ --ignore "*.ilg"
	\ --ignore "*.ind"
	\ --ignore "*.lo[cft]"
	\ -g ""'
else
	" fallback
	let g:ctrlp_user_command = 'find %s -not -path "*/\.*" -type f -exec grep -Iq . {} \; -and -print'
endif

" CtrlP bindings
nnoremap <silent> <Esc>Oa :<C-u>CtrlPBuffer<cr>
nnoremap <silent> <Esc>Ob :<C-u>CtrlPTag<cr>
nnoremap <silent> <Esc>[A :<C-u>CtrlPBuffer<cr>
nnoremap <silent> <Esc>[1;5A :<C-u>CtrlPBuffer<cr>
nnoremap <silent> <Esc>[B :<C-u>CtrlPTag<cr>
nnoremap <silent> <Esc>[1;5B :<C-u>CtrlPTag<cr>

" CtrlP gf alternative
nmap <leader>gf :<C-u>execute ':CtrlP '.g:shs_project_dir<cr><C-\>f

if executable('fzy')
	" Integrate fzy
	function! FzyCommand(choice_command, vim_command)
		try
			let output = system(a:choice_command . " | fzy -l 20")
		catch /Vim:Interrupt/
			" Swallow errors from ^C, allow redraw! below
		endtry
		redraw!
		if v:shell_error == 0 && !empty(output)
			exec a:vim_command . ' ' . output
		endif
	endfunction

	nnoremap <silent> <C-P> :<C-u>call FzyCommand(printf(g:ctrlp_user_command, "."), ":e")<cr>
	nnoremap <silent> <Esc>Oc :<C-u>call FzyCommand(printf(g:ctrlp_user_command, "."), ":e")<cr>
	nnoremap <silent> <Esc>[C :<C-u>call FzyCommand(printf(g:ctrlp_user_command, "."), ":e")<cr>
	nnoremap <silent> <Esc>[1;5C :<C-u>call FzyCommand(printf(g:ctrlp_user_command, "."), ":e")<cr>
	nnoremap <silent> <Esc>Od :<C-u>call FzyCommand(printf(g:ctrlp_user_command, g:shs_project_dir), ":e")<cr>
	nnoremap <silent> <Esc>[D :<C-u>call FzyCommand(printf(g:ctrlp_user_command, g:shs_project_dir), ":e")<cr>
	nnoremap <silent> <Esc>[1;5D :<C-u>call FzyCommand(printf(g:ctrlp_user_command, g:shs_project_dir), ":e")<cr>
	nnoremap <silent> <leader>e :<C-u>call FzyCommand(printf(g:ctrlp_user_command, g:shs_project_dir), ":e")<cr>
else
	" Fall back to CtrlP
	"
	" Ctrl+up	: buffer list
	" Ctrl+down	: ctags list
	" Ctrl+left	: file list from current dir
	" Ctrl+right	: file list (project dir)
	nnoremap <silent> <Esc>Oc :<C-u>CtrlPCurFile<cr>
	nnoremap <silent> <Esc>Od :<C-u>execute ':CtrlP '.g:shs_project_dir<cr>

	" Other console bindings (compatibility)
	nnoremap <silent> <Esc>[C :<C-u>CtrlPCurFile<cr>
	nnoremap <silent> <Esc>[1;5C :<C-u>CtrlPCurFile<cr>
	nnoremap <silent> <Esc>[D :<C-u>execute ':CtrlP '.g:shs_project_dir<cr>
	nnoremap <silent> <Esc>[1;5D :<C-u>execute ':CtrlP '.g:shs_project_dir<cr>
endif

" Fugitive
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gr :Gremove<CR>
augroup fugitive_tweaks
	autocmd!
	autocmd FileType gitcommit nmap <buffer> U :Git checkout -- <C-r><C-g><CR>
	autocmd BufReadPost fugitive://* set bufhidden=delete
augroup end

" Airline
let g:airline_left_sep='>'
let g:airline_right_sep='<'
let g:airline#extensions#csv#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
set laststatus=2

" Syntastic
nnoremap <silent> <leader>ss :SyntasticCheck<CR>
nnoremap <silent> <leader>si :SyntasticInfo<CR>
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {
	\ "mode": "passive",
	\ "active_filetypes": [],
	\ "passive_filetypes": [] }

let s:clang_checker = GetFirstExecutable("clang-check", "clang-check50", "clang-check40")
let s:clang_tidy = GetFirstExecutable("clang-tidy", "clang-tidy50", "clang-tidy40")
let s:clang_c_compiler = GetFirstExecutable("clang", "clang50", "clang40")
let s:clang_cpp_compiler = GetFirstExecutable("clang++", "clang++50", "clang++40")

let g:syntastic_c_checkers = ["clang"]
let g:syntastic_cpp_checkers = ["clang"]
let g:syntastic_c_compiler = s:clang_c_compiler
let g:syntastic_cpp_compiler = s:clang_cpp_compiler
let g:syntastic_clang_check_exec = s:clang_checker
let g:syntastic_clang_tidy_exec = s:clang_tidy
let g:syntastic_c_clang_check_post_args = ""
let g:syntastic_c_clang_tidy_post_args = ""
let g:syntastic_cpp_clang_check_post_args = ""
let g:syntastic_cpp_clang_tidy_post_args = ""
