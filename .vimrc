" Disable the mouse
set mouse=

" Make sure marks are stored
set viminfo='32,f1

" Make sure syntax highlighting is enabled
syntax enable

" Set the color scheme
colorscheme joelcolors

" Make sure backspace works properly
set backspace=2

" Tabs

" Use 4 spaces for tabs
set tabstop=4 shiftwidth=4 softtabstop=4 expandtab

function! ExpandTab()
    let l:names=split(expand('%'), '/')
    if len(l:names) != 0 && l:names[-1] ==? 'Makefile'
        set noexpandtab
    endif
endfunction

augroup expandtabs
    autocmd!
    autocmd BufFilePost * :call ExpandTab()
augroup END

" Set indent
" cinoptions=Ls,:0,(0,g0
" TODO - Customize this more, using indentexpr
filetype indent on
set cinoptions=Ls,:0,(0,g0

augroup indenting
    autocmd!
    autocmd FileType gitconfig filetype indent off
    autocmd FileType html,php filetype indent off | set ai
augroup END

" Enable word wrap
set formatoptions+=t
set textwidth=79

augroup wordwrap
    autocmd!
    autocmd FileType gitcommit setlocal textwidth=72
augroup END

" Map space to centering the screen
nnoremap <Space> zz

" Search Options
set incsearch

augroup spelling
    autocmd!
    autocmd FileType tex setlocal spell
augroup END

" Saving

function! Hash(str)
    return split(system('sha1sum', a:str), ' ')[0]
endfunction

function! GetCurrentHash()
    return Hash(' ' . join(getline(1, '$'), "\n"))
endfunction

function! IsSaved()
    return b:hash ==? GetCurrentHash()
endfunction

function! UpdateSavedHash()
    let b:hash=GetCurrentHash()
endfunction

function! Save()
    let l:hash=GetCurrentHash()
    if l:hash !=? b:hash
        let b:hash=l:hash
        write
    endif
endfunction

function! ResetSaving()
    call UpdateSavedHash()
endfunction

augroup hashing
    autocmd!
    autocmd BufNewFile,BufReadPost,StdinReadPost * :call ResetSaving()
augroup END

function! TrimL(str)
    return substitute(a:str, '\v^\s+', '', '')
endfunction

function! TrimR(str)
    return substitute(a:str, '\v\s+$', '', '')
endfunction

function! Trim(str)
    return TrimR(TrimL(a:str))
endfunction

" Trims the Current line of trailing whitespace
function! TrimC()
    let l:line = line('.')
    call setline(l:line, TrimR(getline(l:line)))
endfunction

" Mapping jk to ESC
set timeoutlen=150

nnoremap <silent> jk :call Save()<CR>
inoremap <silent> jk <ESC>:call TrimC()<BAR>write<BAR>call UpdateSavedHash()<CR>
vnoremap <silent> jk <ESC>:call Save()<CR>
onoremap <silent> jk <ESC>:call Save()<CR>
cnoremap <silent> jk <ESC>:call Save()<CR>

" Comments
" F2 wraps in a comment
" F3 removes a comment

augroup comments
    autocmd!
    autocmd FileType c,cpp,java,javascript :let b:comment='\/\/'
    autocmd FileType python,ruby :let b:comment='#'
    autocmd FileType lisp,scheme,asm :let b:comment=';'
    autocmd FileType vim :let b:comment='"'
augroup END

function! AddComment() range
    let l:c = a:firstline
    let l:min = indent(l:c)

    " while l:c < a:lastline
    "     let l:c = l:c + 1
    "     let l:indent = indent(l:c)

    "     if l:indent < l:min && l:indent != 0
            let l:min = l:indent
        endif
    endwhile " fjirsgfres

    execute ':' . a:firstline . ',' . a:lastline . 's/.\{' . l:min . '\}/\0' . b:comment . ' '
endfunction

function! SubComment()
    let l:linenum = line('.')
    call setline(l:linenum, substitute(getline(l:linenum), '\V\(\s\*\)\('
                \ . b:comment . '\s\*\)\+', '\1', ''))
    " let l:c = a:first
    " let l:linenum=line('.')
    " let l:line=getline(l:linenum)
    " let l:linelen=len(l:line)
    " let l:newline=substitute(l:line, '\V\(\s\*\)\(' . s:comment . '\s\*\)\+',
    "                         \ '\1', '')
    " let l:newlinelen=len(l:newline)
    " let l:cursorcol=getpos('.')[2]
    " call setline(l:linenum, l:newline)
    " let l:newcursorcol=l:cursorcol + l:newlinelen - l:linelen
    " if l:newcursorcol < 0
    "     normal! ^
    " else
    "     call cursor(l:linenum, l:newcursorcol)
    " endif
endfunction

nnoremap <silent> <F2> :call AddComment()<CR>
inoremap <silent> <F2> <ESC>:call AddComment()<CR>a
vnoremap <silent> <F2> :call AddComment()<CR>

nnoremap <silent> <F3> :call SubComment()<CR>
inoremap <silent> <F3> <ESC>:call SubComment()<CR>a
vnoremap <silent> <F3> :call SubComment()<CR>

" Temporary stuff to help learning

" Disable h,j ,k, and l, and the arrow keys
nnoremap h <NOP>
nnoremap j <NOP>
nnoremap k <NOP>
nnoremap l <NOP>
nnoremap <UP> <NOP>
nnoremap <DOWN> <NOP>
nnoremap <LEFT> <NOP>
nnoremap <RIGHT> <NOP>

"Disable Enter and Backspace
nnoremap <CR> <NOP>
nnoremap <BS> <NOP>
