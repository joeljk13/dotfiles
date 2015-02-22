set nocompatible

set sessionoptions-=options

let mapleader = "\<SPACE>"

syntax enable
filetype plugin indent on

augroup syntax_highlighting
    autocmd!
    autocmd BufEnter * :syntax sync fromstart
augroup END

silent! set mouse=n

set viminfo='1024,f1
set history=1024

set virtualedit=block

set t_Co=256
colorscheme delek

set backspace=indent,eol,start

set nojoinspaces

set tabstop=4 softtabstop=0 shiftwidth=4 expandtab

function! SetTabs()
    if &readonly || &buftype ==# "nowrite"
        return
    endif

    if &filetype ==# "make"
        setlocal noexpandtab
        return
    endif

    let l:tabs = search('^\t\+\S', 'n')
    " Ignore 1 space indents; they're probably just for formatting
    let l:spaces = search('^ \{2,\}\S', 'n')

    if l:tabs && l:spaces
        echoerr 'This file uses both spaces and tabs for indentation.'
    elseif l:tabs
        setlocal noexpandtab
    elseif l:spaces
        " The first indent is probably the lowest level of indentation
        let &l:shiftwidth = indent(l:spaces)
        let &l:tabstop = &l:shiftwidth
    endif
endfunction

augroup settabs
    autocmd!
    autocmd FileType * :call SetTabs()
augroup END

" Options from sensible.vim
set nrformats-=octal
set laststatus=2
set lazyredraw
set ruler
set showcmd
set wildmenu
set wildmode=longest:full,full
set scrolloff=2
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set tabpagemax=64

set cinoptions=Ls,:0,(0,g0

augroup indenting
    autocmd!
    autocmd FileType gitconfig filetype indent off
    autocmd FileType html,php filetype indent off | set ai
augroup END

set formatoptions+=ljt
set textwidth=79

augroup wordwrap
    autocmd!
    autocmd FileType gitcommit setlocal textwidth=72
augroup END

" Map space to centering the screen
nnoremap <Space> zz

" Search Options
set incsearch nohlsearch

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

augroup comments
    autocmd!
    autocmd FileType c,cpp,java,javascript :let b:linecomment='//'
    autocmd FileType python,ruby :let b:linecomment='#'
    autocmd FileType lisp,scheme,asm :let b:linecomment=';'
    autocmd FileType vim :let b:linecomment='"'
    autocmd FileType tex :let b:linecomment='%'
augroup END

function! AddLineComment() range
    let l:min = -1
    let l:lines = range(a:firstline, a:lastline)

    " Get the minimal indent and set empty lines to just the comment char(s)
    for l:line in l:lines
        let l:linetext = getline(l:line)

        if empty(l:linetext)
            call setline(l:line, b:linecomment)
        else
            let l:indent = indent(l:line)
            if l:indent < l:min || l:min < 0
                let l:min = l:indent
            endif
        endif
    endfor

    " Indent comments to l:min at least and comment out non-commented out lines
    for l:line in l:lines
        let l:linetext = getline(l:line)
        let l:indent = indent(l:line)

        if l:linetext =~ '\V\^\s\*' . b:linecomment
            let l:spaces = l:min - l:indent
            if l:spaces > 0
                call setline(l:line, printf('%' . l:spaces . 's', '') . l:linetext)
            endif
        else
            call setline(l:line, substitute(l:linetext, '.\{' . l:min . '\}',
                        \ '\0' . b:linecomment . ' ', ''))
        endif
    endfor
endfunction

function! SubLineComment()
    let l:linenum = line('.')
    call setline(l:linenum, substitute(getline(l:linenum), '\V' . b:linecomment
                \ . ' ', '', ''))
endfunction

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

execute pathogen#infect()
