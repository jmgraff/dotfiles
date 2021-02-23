"set termguicolors
filetype on
filetype plugin on
filetype indent on

call pathogen#infect()
call pathogen#helptags() "If you like to get crazy :)

let mapleader=" "
nnoremap <SPACE> <Nop>

"easymotion
map <Leader> <Plug>(easymotion-prefix)

"colors
syntax enable
set background=dark
let g:solarized_termcolors=256
colorscheme solarized
"let g:gruvbox_italic=1
"colorscheme gruvbox

"nerdtree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1

"ctrlp
let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlP'

imap jk <Esc>

"make vim-airline show up
set laststatus=2

"line numbers
"set relativenumber
set number
set cursorline
set cursorcolumn

"searching
set hlsearch
set ignorecase
set smartcase
set incsearch

"indentation
set ai
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Disable auto-comments
set formatoptions-=o
autocmd FileType * setlocal formatoptions-=o

" Backspace behavior to be more intuitive
set backspace=indent,eol,start

set foldmethod=indent
set nofen

"show whitespace
set list
set listchars=tab:»\ ,extends:›,precedes:‹,trail:•

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
"autocmd FileType make set noexpandtab shiftwidth=2 softtabstop=0

" Switch buffers easily with TAB and SHIFT-TAB - this breaks ctrl-i
":nnoremap <Tab> :tabn<CR>
":nnoremap <S-Tab> :tabp<CR>

"nowrap
set nowrap

"turn off swapfiles
set noswapfile

"rolodex h-splits
set noequalalways winminheight=0 winheight=9999 helpheight=9999

"easier tab movement
map <C-l> :tabn<cr>
map <C-h> :tabp<cr>
map <C-j> <C-w><C-j>
map <C-k> <C-w><C-k>

:command! -nargs=+ -complete=file Split
            \  for s:f in [<f-args>]
            \|   for s:m in glob(s:f, 0, 1)
            \|     exe 'split' fnameescape(s:m)
            \|   endfor
            \| endfor
            \| unlet s:f | unlet s:m

augroup filetypedetect
    au BufRead,BufNewFile *.dockerfile setfiletype dockerfile
augroup END

"make Vagrantfiles ruby
autocmd BufNewFile,BufRead Vagrantfile set filetype=ruby
