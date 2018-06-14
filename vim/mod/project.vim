" Figure out project directory (we need only git ;) )
let b:shs_project_dir=getcwd()
while b:shs_project_dir != '/' && empty(glob(b:shs_project_dir . '/.git'))
	let b:shs_project_dir=fnamemodify(b:shs_project_dir, ':h')
endwhile
if b:shs_project_dir == '/'
	" fall back to cwd
	let b:shs_project_dir=getcwd()
endif
