" Figure out project directory (we need only git ;) )
let g:shs_project_dir=getcwd()
while g:shs_project_dir != '/' && empty(glob(g:shs_project_dir . '/.git'))
	let g:shs_project_dir=fnamemodify(g:shs_project_dir, ':h')
endwhile
if g:shs_project_dir == '/'
	" fall back to cwd
	let g:shs_project_dir=getcwd()
endif
