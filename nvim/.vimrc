" Made to be used as a menu, :setlocal foldmethod=marker
" You may have to do ':set foldmarker={{{,}}}' if you've changed it before
echo "HI!"
let configdir = stdpath('config')
lua require('plugins')

" {{{ Keymaps
let mapleader = ","
" {{{ Navigation
" Navigate location list for buffer
nnoremap _ :lprev<CR>
nnoremap + :lnext<CR>

" }}}
" {{{ Text

" Start/end of line
nnoremap H ^
nnoremap L $

" normal: Surround with ' or " quotes
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel

" }}}
" {{{ Buffers
nnoremap Q :bp<bar>sp<bar>bn<bar>bd<CR>

nnoremap <Tab> :bnext<cr>
nnoremap <S-Tab> :bprev<cr>

nnoremap <C-right> :tabnext<cr>
nnoremap <C-left> :tabprev<cr>
nnoremap TT :tab split<cr>
" }}}
" {{{ Yank Put

" Yank clipboard
nnoremap <leader>yc "+y
vnoremap <leader>yc "+y

" }}}
" {{{ Searching
" Automatically change to regular expression search
nnoremap / /\v
nnoremap <leader>sr :%s/
vnoremap <leader>sr :s/
" }}}
" {{{ Quick File
nnoremap <silent> <leader>esn :exe "vsp ".configdir."/UltiSnips"<cr>
nnoremap <silent> <leader>eft :exe "vsp ".configdir."/ftplugin"<cr>
nnoremap <silent> <leader>ev  :exe "vsp ".configdir."/.vimrc"<cr>
" For now syntax is just being done in after
nnoremap <silent> <leader>esy :exe "vsp ".configdir."/after"<cr>
nnoremap <leader>sv :exe "source ".configdir."/.vimrc"<cr>

nnoremap <silent> <leader>ez  :exe "vsp ".$ZDOTDIR."/.zshrc"<cr>
" }}}
" {{{ Fold

" Fold Toggle
nnoremap <space> za
nnoremap z<space> zA

" Set fold methods
nnoremap <leader>fmm :setlocal foldmethod=marker<cr>
nnoremap <leader>fmi :setlocal foldmethod=indent<cr>
nnoremap <leader>fme :setlocal foldmethod=expr<cr>
nnoremap <leader>fms :setlocal foldmethod=syntax<cr>
nnoremap <leader>ft :setlocal foldenable!<cr>

" Echo current fold level
nnoremap <leader>fl :echo foldlevel('.')<cr>
" }}}
" {{{ Extra
" Exit insert mode
inoremap jk <esc>
vnoremap jk <esc>
tnoremap jk <c-\><c-n>

nnoremap <leader>h :vert bo help 

" Toggle Highlighting
nnoremap <leader><space> :set hlsearch!<CR>

nnoremap <leader>sp :setlocal spell!<cr>
vnoremap <leader>ck y:r!cksum <<< "<C-r>"" <bar> cut -f 1 -d ' '<CR>

noremap <leader>qf :call asyncrun#quickfix_toggle(20)<cr>

" [z]oom [i]n/[o]ut using tabs
" https://stackoverflow.com/a/53670916/5332072
nmap <leader>zi :tabnew %<CR>
nmap <leader>zo :tabclose<CR>

" }}}
" {{{ Unmappings
inoremap <esc> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
" }}}
" }}}

" {{{ Commands
" Silent <shellcmd> ~ Run <shellcmd> silently
command!-nargs=1 Silent
            \ exe ':silent !' . <q-args> 
            \| execute ':redraw!'

" R <shellcmd> ~ Read ouput of <shellcmd> to a temp buffer
" https://vim.fandom.com/wiki/Append_output_of_an_external_command
command! -nargs=* -complete=shellcmd R
            \ new
            \| setlocal buftype=nofile bufhidden=hide noswapfile
            \| r !<args>

" Preview (Not working)
" :command! -complete=file MDpreview
"            \ exe ':silent ! grip -b -silent ' . expand('%')
"
vnoremap <silent> i/ :<c-u>call SelectMatch()<cr>
onoremap <silent> i/ :call SelectMatch()<cr>
function! SelectMatch()
    if search(@/, 'bcW')
        norm! v
        call search(@/, 'ceW')
    else
        norm! gv
    endif
endfunction

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
nnoremap <leader>syn :call SynGroup()<cr>

" }}}

" {{{ Settings
set autoindent
set nocp
filetype plugin indent on

set foldmethod=expr
set foldopen-=block
set completeopt=menuone,preview
set nolazyredraw
set nonumber cursorline
set hlsearch incsearch
set wrap
set ttyfast
set scrolloff=10
set autowrite
set modelines=0
set smartcase
set showmode
set colorcolumn=""
set showtabline=1
set list
set listchars=tab:>>,extends:›,precedes:‹,nbsp:·,trail:·
set fillchars=eob:\ ,fold:\ ,foldsep:\ 
set conceallevel=2
set expandtab
set tabstop=4 softtabstop=2 shiftwidth=4 smarttab smartindent
set backspace=indent,eol,start " Fixes general issues with backspaces on different systems
set splitright splitbelow
set diffopt+=vertical
set wildmode=longest,list,full
set wildmenu
set cul

set signcolumn=yes:1


let g:python3_host_prog='/home/skantify/.pyenv/versions/3.10.7/bin/python'

" }}}

" {{{ Insert Mode/ Normal mode identifier
augroup InsertCursor
    autocmd!
    autocmd InsertEnter * exec 'hi CursorLine'.' gui=bold,underline'
    autocmd InsertLeave * exec 'hi CursorLine'.' gui=underline'
augroup END
" }}}

" {{{ Paths, Globals
let g:shell = 'kitty'
let g:dotdir = expand('~/Desktop/.dot')
"let g:python3_host_prog= expand("~/.dot/venvs/vim_python_venv/bin")
let g:python_host_prog="~/.pyenv/versions/2.7.17/bin/python2.7"
" }}}

" {{{ Wildignore
" https://sanctum.geek.nz/arabesque/vim-filename-completion/
set wildignore+=*.a,*.o
"set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=.DS_Store,.git,.hg,.svn,.venv
set wildignore+=*/__pycache__/*,*/.mypy_cache/*
set wildignore+=*~,*.swp,*.tmp
" }}}
