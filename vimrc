""
"" Thanks:
""   Gary Bernhardt  <destroyallsoftware.com>
""   Drew Neil  <vimcasts.org>
""   Tim Pope  <tbaggery.com>
""   Janus  <github.com/carlhuda/janus>
""

set nocompatible
set encoding=utf-8
set exrc                    " load vimrc from current directory

call pathogen#infect()
filetype plugin indent on

runtime macros/matchit.vim  " enables % to cycle through `if/else/endif`

syntax enable
set background=dark
color Monokai
set synmaxcol=800           " don't try to highlight long lines

set nonumber    " line numbers aren't needed
set ruler       " show the cursor position all the time
set cursorline  " highlight the line of the cursor
set showcmd     " show partial commands below the status line
set shell=bash  " avoids munging PATH under zsh
let g:is_bash=1 " default shell syntax
set history=200 " remember more Ex commands
set scrolloff=3 " have some context around the current line always on screen

" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

" Auto-reload buffers when file changed on disk
set autoread

" Disable swap files; systems don't crash that often these days
set updatecount=0

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

"" Whitespace
set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " backspace through everything in insert mode
" Joining lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j            " Delete comment char when joining commented lines
endif
set nojoinspaces                  " Use only 1 space after "." when joining lines, not 2
" Indicator chars
set listchars=tab:▸\ ,extends:❯,precedes:❮
set showbreak=↪\ 

"" Searching
set hlsearch                      " highlight matches
set incsearch                     " incremental searching
set ignorecase                    " searches are case insensitive...
set smartcase                     " ... unless they contain at least one capital letter
set gdefault                      " have :s///g flag by default on
set showmatch

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=100

function s:setupWrapping()
  set wrap
  set wrapmargin=2
  set textwidth=80
endfunction

if has("autocmd")
  " Avoid showing trailing whitespace when in insert mode
  au InsertEnter * :set listchars-=trail:•
  au InsertLeave * :set listchars+=trail:•

  " In Makefiles, use real tabs, not tabs expanded to spaces
  au FileType make set noexpandtab

  " Make sure all markdown files have the correct filetype set and setup wrapping
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown | call s:setupWrapping()

  " Treat JSON files like JavaScript
  au BufNewFile,BufRead *.json set ft=javascript

  " https://github.com/sstephenson/bats
  au BufNewFile,BufRead *.bats set ft=sh

  " make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
  au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g`\"" | endif

  " mark Jekyll YAML frontmatter as comment
  au BufNewFile,BufRead *.{md,markdown,html,xml} sy match Comment /\%^---\_.\{-}---$/

  " magic markers: enable using `H/S/J/C to jump back to
  " last HTML, stylesheet, JS or Ruby code buffer
  au BufLeave *.{erb,html}      exe "normal! mH"
  au BufLeave *.{css,scss,sass} exe "normal! mS"
  au BufLeave *.{js,coffee}     exe "normal! mJ"
  au BufLeave *.{rb}            exe "normal! mC"
endif

" don't use Ex mode, use Q for formatting
map Q gq

" clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>

let mapleader=","

" paste lines from unnamed register and fix indentation
nmap <leader>p pV`]=
nmap <leader>P PV`]=

" yank/paste to system register
map <leader>ys "*y<cr>
map <leader>ps "*p<cr>

" http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" reindent whole file.. jump back to original spot via mark x
map <leader>r gg=G

map <leader>f :CtrlP<cr>
map <leader>F :CtrlPMRUFiles<cr>
map <leader>b :CtrlPBuffer<cr>
map <leader>B :CtrlPBufTag<cr>

let g:ctrlp_root_markers = ['.git', 'Rakefile']
let g:ctrlp_working_path_mode = 0
" let g:ctrlp_extensions = ['tag', 'buffertag']
let g:ctrlp_custom_ignore = { 'dir': '\v[\/](\.bundle|bundle|coverage|log)$' }

" let g:turbux_command_test_unit = 'ruby -Ilib:test'
" let g:turbux_command_cucumber = 'cucumber -f progress'

let g:ackprg = 'ag --nogroup --nocolor --column'

" In command-line mode, C-a jumps to beginning (to match C-e)
cnoremap <C-a> <Home>

" ignore Rubinius, Sass cache files
set wildignore+=tmp/**,*.rbc,.rbx,*.scssc,*.sassc
" ignore Bundler standalone/vendor installs & gems
set wildignore+=bundle/**,vendor/bundle/**,vendor/cache/**
set wildignore+=node_modules/**

" nice tab completion on : commands
set wildmenu
set wildmode=longest:full,full

" toggle between last open buffers
" nnoremap <leader><leader> <c-^>

command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>

" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

set splitright
set splitbelow

" disable cursor keys in normal mode
" map <Left>  :echo "no!"<cr>
" map <Right> :echo "no!"<cr>
" map <Up>    :echo "no!"<cr>
" map <Down>  :echo "no!"<cr>

""  Fix normal jk movement
nnoremap j gj
nnoremap k gk

nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
set pastetoggle=<F3>

""  Ack
nnoremap <leader>a :Ack!

""  Reselect pasted text
nnoremap <leader>v V`]

""  Create new split
nnoremap <leader>w <C-w>v<C-w>l

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

" mouse!
set mouse=a
set mousehide

" No swap files
set noswapfile
set nobackup
set nowritebackup

" Persistent Undo
silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile

" Stay in visual mode for indents
vnoremap < <gv
vnoremap > >gv

" Status line
if has('statusline')
  set laststatus=2
  set noshowmode
  set statusline=%<%f\                     " Filename
  set statusline+=%w%h%m%r                 " Options
  set statusline+=%{fugitive#statusline()} " Git Hotness
  set statusline+=\ [%{&ff}/%Y]            " Filetype
  set statusline+=\ [%{getcwd()}]          " Current dir
  set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

" powerline (enabling)
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
set t_Co=256

" json.  From vim-json plugin.  Reformat from yajl (brew install yajl)
autocmd BufRead,BufNewFile *.json set filetype=json
autocmd FileType json set equalprg=json_reformat

