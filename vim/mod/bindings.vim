let mapleader = '\'

" previous/next buffer
nnoremap <silent> <leader>p :<C-u>bp<cr>
nnoremap <silent> <leader>n :<C-u>bn<cr>

" ***** Treat URLs *****

function! Browser ()
    let line = getline (".")
    let line = matchstr (line, "http[^ ]*")
    exec ":silent !$BROWSER ".line
endfunction

nnoremap <silent> <leader>ow :call Browser()<CR>
nnoremap <silent> <leader>s :call SynGroup()<CR>
