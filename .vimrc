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

let mapleader = '\\LEADER\\'
nmap <space> \\LEADER\\

function! IsWritable()
    return !&readonly && &buftype == "" && &modifiable
endfunction

" Enable plugins and set their settings

" Syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_error_symbol = "✗"
let g:syntastic_style_error_symbol = "✗"
let g:syntastic_warning_symbol = "✗"
let g:syntastic_style_warning_symbol = "✗"
let g:syntastic_enable_balloons = 1
let g:syntastic_auto_loc_list = 1

let g:syntastic_c_check_header = 1
let g:syntastic_c_compiler_options = '-Wall -Wextra -Wundef -Wshadow'
    \ . ' -Wcast-align -Wjump-misses-init -Wstrict-prototypes'
    \ . ' -Wstrict-overflow=4 -Wwrite-strings -Waggregate-return -Wcast-qual'
    \ . ' -Wswitch-default -Wstrict-aliasing -Wconversion -Wunreachable-code'
    \ . ' -Wformat=2 -Winit-self -Wuninitialized -Wmissing-prototypes'
    \ . ' -Wold-style-definition -Wdouble-promotion'
    \ . ' -Wsuggest-attribute=noreturn -Wsuggest-attribute=format'
    \ . ' -Wdeclaration-after-statement -Wunsafe-loop-optimizations'
    \ . ' -Wmissing-declarations -Wmissing-field-initializers'
    \ . ' -Wredundant-decls -Winline -Wvla -Wdisabled-optimization'
    \ . ' -Wstack-protector -Wvector-operation-performance'
    \ . ' -pedantic-errors -Werror -Wno-error=cast-align -Wno-error=cast-qual'
    \ . ' -std=c99'

let g:syntastic_cpp_check_header = g:syntastic_c_check_header
let g:syntastic_cpp_compiler_options = g:syntastic_c_compiler_options

" Colorschemes

let g:solarized_termcolors=256

" Airline

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline#extensions#whitespace#enabled = 1
" I don't understand how/whether indent checking works yet
let g:airline#extensions#whitespace#checks =  ['indent', 'trailing']
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tmuxline#enabled = 0
let g:airline_powerline_fonts = 1

" Tmuxline

let g:tmuxline_theme = 'vim_powerline'

" LaTeX-Box

let g:LatexBox_complete_inlineMath = 1
let g:LatexBox_Folding = 1

" Sneak

let g:sneak#streak = 1
let g:sneak#streak_esc = "\<f13>"

" Move

let g:move_key_modifier = 'C'

" Over

nnoremap <leader>v :OverCommandLine<cr>

" Unite

nnoremap <leader>u :Unite -auto-resize -auto-preview<space>

" delimitMate

let g:delimitMate_offByDefault = 1
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1

" Vimux

nnoremap <leader>tp :VimuxPromptCommand<cr>
nnoremap <leader>tl :VimuxRunLastCommand<cr>
nnoremap <leader>tq :VimuxCloseRunner<cr>

" Tagbar

nnoremap <leader>b :TagbarToggle<cr>

" Python-mode

let g:pymode_trim_whitespaces = 1
let g:pymode_options = 0
let g:pymode_indent = 0
let g:pymode_run_bind = '<leader>pr'
let g:pynode_breakpoint_bind = '<leader>pb'
let g:pymode_lint_ignore = "E302"
let g:pymode_rope_goto_definition_bind = '<c-]>'
let g:pymode_rope_rename_bind = '<leader>pn'
let g:pymode_rope_rename_module_bind = '<leader>pm'
let g:pymode_rope_rename_imports_bind = '<leader>po'
let g:pymode_rope_autoimport_bind = '<leader>pi'
let g:pymore_rope_module_to_package_bind = '<leader>pp'
let g:pymore_rope_extract_method_bind = '<leader>pf'
let g:pymore_rope_extract_variable_bind = '<leader>pv'
let g:pymore_rope_use_function_bind = '<leader>pu'
let g:pymode_rope_move_bind = '<leader>pa'
let g:pymode_rope_change_signature_bind = '<leader>ps'

" Colorizer

nnoremap <leader>cC :ColorToggle<cr>
xnoremap <leader>cC :ColorToggle<cr>
nnoremap <leader>cT :ColorContrast<cr>
xnoremap <leader>cT :ColorContrast<cr>
nnoremap <leader>cf :ColorSwapFgBg<cr>
xnoremap <leader>cF :ColorSwapFgBg<cr>

execute pathogen#infect()

augroup vimrc_syntastic
    autocmd!
    autocmd BufRead * if !IsWritable() | let b:syntastic_mode = "passive" | endif
augroup END

" Rainbow Parentheses

augroup vimrc_rainbow_parentheses
    autocmd!
    autocmd VimEnter * RainbowParenthesesToggle
    autocmd Syntax * RainbowParenthesesLoadRound
    autocmd Syntax * RainbowParenthesesLoadSquare
    autocmd Syntax * RainbowParenthesesLoadBraces
augroup END

" Litecorrect

call litecorrect#init()

" Colors and syntax highlighting

set t_ut= background=dark
colorscheme badwolf

augroup syntax_highlighting
    autocmd!
    autocmd BufEnter * syntax sync fromstart
augroup END

augroup vimrc_filetypes
    autocmd!
    autocmd BufNewFile,BufRead *.md set filetype=markdown
augroup END

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

augroup vimrc_indenting
    autocmd!
    autocmd FileType gitconfig filetype indent off
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
set timeout ttimeout timeoutlen=1000 ttimeoutlen=100
set splitright splitbelow

set backup
set backupdir=~/.vim/backup

nnoremap <leader>o o<esc>O
nnoremap <leader>O O<esc>o

" Use yy instead. Now Y is consistend with C and D.
nnoremap Y y$

" Window/buffer mappings

nnoremap <leader>- <c-w>s
nnoremap <leader>\ <c-w>v
nnoremap <leader>w- <c-w>s
nnoremap <leader>w\ <c-w>v
nnoremap <leader>wo <c-w>o

" Search settings

set incsearch nohlsearch ignorecase smartcase

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

" Word wrapping settings

set formatoptions+=ljtcroq
set textwidth=79

augroup wordwrap
    autocmd!
    autocmd FileType gitcommit setlocal textwidth=72
augroup END

nnoremap <leader><space> zz

augroup vimrc_spelling
    autocmd!
    autocmd FileType tex,gitcommit,text setlocal spell
    autocmd FileType * if !IsWritable() | setlocal nospell | endif
augroup END

" Saving

function! s:Hash(str)
    return split(system('sha1sum', a:str), ' ')[0]
endfunction

function! s:BufHash()
    return s:Hash(' ' . join(getline(1, '$'), "\n"))
endfunction

function! s:Save()
    if !IsWritable()
        return
    endif

    let l:hash = s:BufHash()
    if l:hash != b:hash
        let b:hash = l:hash
        write
    endif
    set nomodified
endfunction

augroup vimrc_hashing
    autocmd!
    autocmd BufEnter * let b:hash = s:BufHash()
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

" Trims the current line of trailing whitespace
function! s:TrimC()
    let l:line = line('.')
    call setline(l:line, TrimR(getline(l:line)))
endfunction

set <f13>=jk
nnoremap <silent> <f13> :call <sid>Save()<cr>
inoremap <silent> <f13> <esc>:call <sid>TrimC()<bar>call <sid>Save()<cr>
vnoremap <silent> <f13> <esc>
onoremap <silent> <f13> <esc>
cnoremap <silent> <f13> <esc>

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
