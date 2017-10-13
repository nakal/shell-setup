" Find first executable in list or fallback
function! GetFirstExecutable(fallback, ...)
	for e in a:000
		if executable(e)
			return e
		endif
	endfor
	return a:fallback
endfunction

" Fixups for colorscheme
function! FixColorscheme()
       highlight! IncSearch ctermfg=172 ctermbg=16
       highlight! Error term=reverse ctermfg=white ctermbg=red guifg=white guibg=red
endfun
