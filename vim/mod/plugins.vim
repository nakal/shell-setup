" Fix home/end key bindings
" nnoremap <silent> <Esc>[7~ ^
" nnoremap <silent> <Esc>[8~ $
" inoremap <silent> <Esc>[7~ <Esc>^i
" inoremap <silent> <Esc>[8~ <Esc>$a

" FZF bindings
nnoremap <silent> <Esc>Oa :<C-u>Buffers<cr>
nnoremap <silent> <Esc>Ob :<C-u>Tags<cr>
nnoremap <silent> <Esc>[A :<C-u>Buffers<cr>
nnoremap <silent> <Esc>[1;5A :<C-u>Buffers<cr>
nnoremap <silent> <Esc>[B :<C-u>Tags<cr>
nnoremap <silent> <Esc>[1;5B :<C-u>Tags<cr>

" FZF gf alternative
"nmap <leader>gf :<C-u>execute ':GFiles '.g:shs_project_dir.' h'<cr>
let g:fzf_tags_command = GetFirstExecutable("exctags", "tags").' -R'

" GFiles, fallback Files .
function! FZFTryGFiles(dir)
	let err = system("git rev-parse --is-inside-work-tree")
	if v:shell_error == 0
		exec ":GFiles"
	else
		exec ":Files ".a:dir
	endif
endfunction

function! FZFFile()
	call fzf#vim#gitfiles(g:shs_project_dir, { 'options': [ '--query', expand("<cfile>"), '--select-1', '--exit-0' ] })
endfunction

nmap <leader>gf :<C-u>:call FZFFile()<cr>

nnoremap <silent> <C-P> <C-u>:call FZFTryGFiles(".")<cr>
nnoremap <silent> <Esc>Oc :<C-u>:Files .<cr>
nnoremap <silent> <Esc>[C :<C-u>:Files .<cr>
nnoremap <silent> <Esc>[1;5C :<C-u>:Files .<cr>
nnoremap <silent> <Esc>Od :<C-u>call FZFTryGFiles(g:shs_project_dir)<cr>
nnoremap <silent> <Esc>[D :<C-u>call FZFTryGFiles(g:shs_project_dir)<cr>
nnoremap <silent> <Esc>[1;5D :<C-u>call FZFTryGFiles(g:shs_project_dir)<cr>
nnoremap <silent> <leader>e :<C-u>call FZFTryGFiles(g:shs_project_dir)<cr>

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
