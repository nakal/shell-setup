let mapleader = '\'

" previous/next buffer
nnoremap <silent> <leader>p :<C-u>bp<cr>
nnoremap <silent> <leader>n :<C-u>bn<cr>

" ***** Treat URLs *****

function! Browser ()
    let line = getline (".")
    let line = matchstr (line, "http[^ ]*")
    exec ":silent !firefox ".line
endfunction

nnoremap <silent> <leader>w :call Browser()<CR>
nnoremap <silent> <leader>s :call SynGroup()<CR>
