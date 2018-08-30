" Find first executable in list or fallback
function! GetFirstExecutable(fallback, ...)
	for e in a:000
		if executable(e)
			return e
		endif
	endfor
	return a:fallback
endfunction

" Find first directory path in list or fallback
function! GetFirstDirectory(fallback, ...)
	for d in a:000
		if isdirectory(d)
			return d
		endif
	endfor
	return a:fallback
endfunction

" Helpers for colorscheme
function! FixColorscheme()
       highlight! IncSearch ctermfg=172 ctermbg=16
       highlight! Error term=reverse ctermfg=white ctermbg=red guifg=white guibg=red
       highlight! MatchParen term=NONE ctermfg=7 ctermbg=39 gui=underline guifg=#61AFEF
endfun

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
