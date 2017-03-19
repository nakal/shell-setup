" Figure out project directory (we need only git ;) )
let g:shs_project_dir=getcwd()
while g:shs_project_dir != '/' && empty(glob(g:shs_project_dir . '/.git'))
	let g:shs_project_dir=fnamemodify(g:shs_project_dir, ':h')
endwhile
if g:shs_project_dir == '/'
	" fall back to cwd
	let g:shs_project_dir=getcwd()
endif

" Read project-local .vimrc, if any
let s:vimrc_path = g:shs_project_dir . '/.vimrc'
if filereadable(s:vimrc_path)
	execute 'source' s:vimrc_path
endif

" Add project-local ctags database, if any
" This is needed when CWD != project dir
let s:ctags_path = g:shs_project_dir . '/.git/ctags'
if filereadable(s:ctags_path)
	set tags+=s:vimrc_path
endif

" CScope

if has('cscope')
	function! Cscope_load ()
		let l:cscope_path = g:shs_project_dir . '/.git/cscope.db'
		if filereadable(l:cscope_path)
			execute 'cs add' l:cscope_path
		endif
	endfunction

	set cscopetag
	set cscopeverbose

	if has('quickfix')
		set cscopequickfix=s-,c-,d-,i-,t-,e-
	endif

	" cnoreabbrev csa cs add
	" cnoreabbrev csf cs find
	" cnoreabbrev csk cs kill
	" cnoreabbrev csr cs reset
	" cnoreabbrev ^css cs show
	" cnoreabbrev csh cs help

	silent call Cscope_load()
endif
