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

let mapleader = ':LEADER'
nmap <space> :LEADER
xmap <space> :LEADER

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
let g:syntastic_auto_loc_list = 0

" lacheck is really stupid and can't suppress warnings/errors, so just don't
" use it.
let g:syntastic_tex_checkers = ['chktex']

let g:syntastic_c_check_header = 1
let g:syntastic_cpp_check_header = g:syntastic_c_check_header

let s:compiler_options = '-Wall -Wextra -Wundef -Wshadow'
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

let g:syntastic_c_compiler_options = s:compiler_options . ' -std=gnu99'
let g:syntastic_cpp_compiler_options = s:compiler_options . ' -std=gnu++11'

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

" haskellmode

let g:haddock_browser = "/usr/bin/firefox"

execute pathogen#infect()

augroup vimrc_syntastic
    autocmd!
    autocmd BufRead * if !IsWritable() | let b:syntastic_mode = "passive" | endif
augroup END

augroup vimrc_haskellmode
    autocmd!
    autocmd BufEnter *.hs compiler ghc
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
inoremap <s-tab> <c-d>
set smarttab

function! s:AutoTab()
    if !IsWritable()
        return
    endif

    if &filetype == "make"
        setlocal noexpandtab
        return
    endif

    let l:pos = getcurpos()
    call cursor(1, 1)

    let l:tabs = search('^\t\+\S', 'n')
    " Only consider 2, 4, or 8 space indents; otherwise it's probably just for
    " formatting
    let l:spaces = search('\v^(  |    |        )\S', 'n')

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

    call cursor(l:pos[1:])
endfunction

augroup vimrc_autotab
    autocmd!
    autocmd BufRead * call s:AutoTab()
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
set mouse=
silent! set mouse=n

" These may be essential enough to go in the top section, but I'm not sure.
set wildmenu
set wildmode=longest:full,full

set complete+=i
set display=uhex
set sessionoptions-=options
set viminfo=%,'1024,f1,!
set history=1024
set virtualedit=block
set nojoinspaces
set nrformats-=octal
set laststatus=2
set lazyredraw
set ruler
set showcmd
set scrolloff=1
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set tabpagemax=64
set cinoptions=Ls,:0,(s,g0
set timeout ttimeout timeoutlen=1000 ttimeoutlen=100
set splitright splitbelow

set backup
set backupdir=~/.vim/backup

nnoremap <leader>o o<esc>O
nnoremap <leader>O O<esc>o

" Use yy instead. Now Y is consistend with C and D.
nnoremap Y y$

nnoremap U <c-r>

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

set <f14>=kj
nmap <silent> <f14> <f13>
imap <silent> <f14> <f13>
vmap <silent> <f14> <f13>
omap <silent> <f14> <f13>
cmap <silent> <f14> <f13>

augroup vimrc_comments
    autocmd!

    " These are characters that will comment out the rest of that line
    autocmd FileType c,cpp,java,javascript let b:linecomment = '//'
    autocmd FileType python,ruby let b:linecomment = '#'
    autocmd FileType lisp,scheme,asm let b:linecomment = ';'
    autocmd FileType vim let b:linecomment = '"'
    autocmd FileType tex let b:linecomment = '%'
augroup END

function! SetLineComment()
    if exists('b:linecomment')
        return
    endif

    if &commentstring =~ '\s*%s$'
        let b:linecomment = substitute(&commentstring, '\s*%s$', '', '')
    else
        echoerr 'Could not set line comment.'
    endif
endfunction

" Assumes b:linecomment exists.
function! AddLineComment() range
    let l:min = -1
    let l:lines = range(a:firstline, a:lastline)

    for l:line in l:lines
        let l:linetext = getline(l:line)

        if !empty(l:linetext)
            let l:indent = indent(l:line)
            if l:indent < l:min || l:min < 0
                let l:min = l:indent
            endif
        endif
    endfor

    for l:line in l:lines
        let l:text = getline(l:line)

        if empty(l:text)
            let l:newtext = repeat(" ", l:min) . b:linecomment
        else
            let l:newtext = substitute(l:text, '.\{' . l:min . '\}', '\0' .
                        \ b:linecomment . ' ', '')
        endif

        call setline(l:line, l:newtext)
    endfor
endfunction

" Assumes the line is actually commented out with b:linecomment.
function! SubLineComment()
    let l:line = line('.')
    let l:text = getline(l:line)

    if l:text =~ '\V\^\s\*' . b:linecomment . '\$'
        let l:newtext = ""
    else
        let l:newtext = substitute(l:text, '\V' . b:linecomment . ' ', '', '')
    endif

    call setline(l:line, l:newtext)
endfunction

" These will probably support multi-line comments at some point, but their use
" is rare enough for me not to warrant special treatment - it's easier to just
" type them in.

function! AddComment() range
    if !exists('b:linecomment')
        call SetLineComment()
    endif

    execute a:firstline . ',' . a:lastline . 'call AddLineComment()'
endfunction

function! SubComment() range
    if !exists('b:linecomment')
        call SetLineComment()
    endif

    execute a:firstline . ',' . a:lastline . 'call SubLineComment()'
endfunction

function! s:AddComment_(type)
    execute line("'[") . ',' . line("']") . 'call AddComment()'
endfunction

function! s:SubComment_(type)
    execute line("'[") . ',' . line("']") . 'call SubComment()'
endfunction

command! -range -bar AddComment execute <line1> . ',' . <line2> .
            \ 'call AddComment()'
command! -range -bar SubComment execute <line1> . ',' . <line2> .
            \ 'call SubComment()'

xnoremap <silent> <leader>ca :AddComment<cr>
nnoremap <silent> <leader>ca :<c-u>set opfunc=<sid>AddComment_<cr>g@
nnoremap <silent> <leader>cca :<c-u>set opfunc=<sid>AddComment_<cr>:execute
            \ 'normal! ' . v:count1 . 'g@_'<cr>

xnoremap <silent> <leader>cs :SubComment<cr>
nnoremap <silent> <leader>cs :<c-u>set opfunc=<sid>SubComment_<cr>g@
nnoremap <silent> <leader>ccs :<c-u>set opfunc=<sid>SubComment_<cr>:execute
            \ 'normal! ' . v:count1 . 'g@_'<cr>

let s:dirs = []

function! FindFiles(names)
    let l:files = []
    for l:dir in s:dirs
        for l:name in a:names
            let l:file = l:dir . '/' . l:name
            if filereadable(l:file)
                let l:files = l:files + [[l:dir, l:file]]
            endif
        endfor
    endfor
    return l:files
endfunction

function! s:FindTags()
    let l:files = FindFiles(['tags', 'TAGS'])
    set tags=
    for l:dirfile in l:files
        if empty(&tags)
            let &tags = l:dirfile[1]
        else
            let &tags = &tags . ',' . l:dirfile[1]
        endif
    endfor
endfunction

function! s:FindCScope()
    let l:files = FindFiles(['cscope.out'])
    silent cscope kill -1
    for l:dirfile in l:files
        silent execute 'cscope add ' . l:dirfile[1] . ' ' . l:dirfile[0]
    endfor
endfunction

function! AddDir(dir)
    if !isdirectory(a:dir)
        echoerr 'Could not add invalid directory ' . a:dir
        return
    endif

    let l:dir = a:dir
    while isdirectory(l:dir) && l:dir !=# fnamemodify(l:dir, ':h')
        let s:dirs = s:dirs + [l:dir]
        let dir = fnamemodify(dir, ':h')
    endwhile

    call uniq(sort(s:dirs))

    call s:FindTags()
    call s:FindCScope()
endfunction

augroup vimrc_files
    autocmd!
    autocmd BufRead * call AddDir(expand('%:p:h'))
augroup END

function! UpdateCTags()
    call system("ctags -R .")
    call s:FindTags()
endfunction

function! UpdateCScope()
    call system("cscope -bR")
    call s:FindCScope()
endfunction

nnoremap <silent> <leader>tt :call UpdateCTags() <bar> call UpdateCScope()<cr>

nnoremap <leader>fs yiw:cscope find s "<cr>
nnoremap <leader>fd yiw:cscope find g "<cr>
nnoremap <leader>fc yiw:cscope find c "<cr>
nnoremap <leader>ft yiw:cscope find t "<cr>
nnoremap <leader>fg yiw:cscope find e "<cr>
nnoremap <leader>ff yiw:cscope find f "<cr>
nnoremap <leader>fi yiw:cscope find i "<cr>
nnoremap <leader>fa yiw:cscope find a "<cr>

" To create temporary vimscript inline in a file and run in, just select it in
" visual mode and type `:call Execute()`. Another option would be to create a
" tmp.vim file with the code and then source it.
function! Execute() range
    let l:lines =  join(getbufline("%", a:firstline, a:lastline), "\n")
    let l:script = substitute(l:lines, '\n\s*\\', '', 'g')
    execute l:script
endfunction
