" Essential settings
"
" These can be abbreviated with:
" se nocp bs=2 | sy enable
" filetype plugin indent on
"
" Also make sure to do
" noremap jk <esc>
" noremap! jk <esc>
" when this .vimrc isn't available.

set nocompatible backspace=indent,eol,start
syntax enable
filetype plugin indent on

" General settings/functions that could affect other
" settings/mappings/functinons/etc or are likely to be used by them

let mapleader = "\<space>"

function! IsWritable()
    return !&readonly && &buftype == "" && &modifiable
endfunction

" Tabs and spaces settings for indenting

set tabstop=4 softtabstop=0 shiftwidth=4 expandtab

function! s:AutoTab()
    if !IsWritable()
        return
    endif

    if &filetype == "make"
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
    " else
    "   use user-set defaults
    endif
endfunction

augroup vimrc_autotab
    autocmd!
    autocmd FileType * call s:AutoTab()
augroup END

" Toggle among both of 'number' and 'relativenumber', just 'number', and
" neither.
function! s:SetNumber()
    if !&number && !&relativenumber
        set number
    elseif &relativenumber
        set norelativenumber nonumber
    else
        " &number && !&relativenumber
        set relativenumber
    endif
endfunction

nnoremap <leader>n :call <sid>SetNumber()<cr>

" Colors and syntax highlighting

colorscheme delek

augroup syntax_highlighting
    autocmd!
    autocmd BufEnter * syntax sync fromstart
augroup END

" Miscellaneous settings

" This fails when editing crontab on ssh, but I don't really care for the mouse
" that much anyway, so just ignore errors.
silent! set mouse=n

" These may be essential enough to go in the top section, but I'm not sure.
set wildmenu
set wildmode=longest:full,full

set sessionoptions-=options
set viminfo='1024,f1
set history=1024
set virtualedit=block
set nojoinspaces
set nrformats-=octal
set laststatus=2
set lazyredraw
set ruler
set showcmd
set scrolloff=2
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set tabpagemax=64
set cinoptions=Ls,:0,(0,g0

" Search settings

set incsearch nohlsearch

" Use Hx and Lx like Fx and fx in normal mode, but H and L will search across
" lines.
"
" There doesn't seem to be an elegant way of doing this in vim (if it's even
" possible in general), so just loop through all characters and define a
" mapping manually for each.
for s:c in split('abcdefghijklmnopqrstuvwxyz0123456789`~!@#$%^&*()-_=+[{]}\;:''",<.>/? ', '\zs')
    execute 'nnoremap H' . s:c . ' ?' . s:c . '<cr>'
    execute 'nnoremap L' . s:c . ' /' . s:c . '<cr>'
endfor
nnoremap H<bar> ?<bar><cr>
nnoremap L<bar> /<bar><cr>

augroup vimrc_indenting
    autocmd!
    autocmd FileType gitconfig filetype indent off
augroup END

" Word wrapping settings

set formatoptions+=ljt
set textwidth=79

augroup wordwrap
    autocmd!
    autocmd FileType gitcommit setlocal textwidth=72
augroup END

nnoremap <leader><space> zz

augroup vimrc_spelling
    autocmd!
    autocmd FileType tex,gitcommit,text setlocal spell
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

augroup vimrc_hashing
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

nnoremap <silent> jk :call Save()<cr>
inoremap <silent> jk <esc>:call TrimC()<bar>write<bar>call UpdateSavedHash()<cr>
vnoremap <silent> jk <esc>:call Save()<cr>
onoremap <silent> jk <esc>:call Save()<cr>
cnoremap <silent> jk <esc>:call Save()<cr>

augroup vimrc_comments
    autocmd!
    autocmd FileType c,cpp,java,javascript :let b:linecomment='//'
    autocmd FileType python,ruby :let b:linecomment='#'
    autocmd FileType lisp,scheme,asm :let b:linecomment=';'
    autocmd FileType vim :let b:linecomment='"'
    autocmd FileType tex :let b:linecomment='%'
augroup END

" TODO - fix the commenting functions. They don't really work at the moment.

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

" To create temporary vimscript inline in a file and run in, just select it in
" visual mode and type `:call Execute()`. Another option would be to create a
" tmp.vim file with the code and then source it.
function! Execute() range
    let l:lines =  join(getbufline("%", a:firstline, a:lastline), "\n")
    let l:script = substitute(l:lines, '\n\s*\\', '', 'g')
    execute l:script
endfunction

execute pathogen#infect()
