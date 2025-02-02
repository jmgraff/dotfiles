"set termguicolors
filetype on
filetype plugin on
filetype plugin indent on

call pathogen#infect()
call pathogen#helptags()

let mapleader=" "
nnoremap <SPACE> <Nop>

"easymotion
map <Leader> <Plug>(easymotion-prefix)

"colors
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
let g:ctrlp_custom_ignore = 'node_modules'

"make vim-airline show up
set laststatus=2

"line numbers
set number
set cursorline
set cursorcolumn

"searching
set hlsearch
set ignorecase
set smartcase
set incsearch

"indentation
set smartindent
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

augroup filetypedetect
    au BufRead,BufNewFile *.dockerfile setfiletype dockerfile
augroup END

""""""""""""""""""""""""""""
" CoC
""""""""""""""""""""""""""""
let g:coc_disable_startup_warning = 1
let g:coc_node_path = '~/.vim/node-v22.10.0-linux-x64/bin/node'
let g:coc_config_home = '~/.vim/coc'
let g:coc_data_home = '~/.vim/coc'
set cmdheight=2
set signcolumn=yes

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
