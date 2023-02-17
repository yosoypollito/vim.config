set number
set mouse=a
set numberwidth=1
set clipboard=unnamed
syntax enable
set showcmd
set ruler
set encoding=utf-8
set showmatch
set sw=2
set relativenumber
set ma

call plug#begin("~/.vim/plugged")

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'eslint/eslint'
Plug 'easymotion/vim-easymotion' " Easy movement
" Plug 'scrooloose/nerdtree' " Explorer
Plug 'nvim-tree/nvim-tree.lua' " New explorer
Plug 'nvim-tree/nvim-web-devicons' " Icons tree

Plug 'christoomey/vim-tmux-navigator' " Can move through tabs
Plug 'itchyny/lightline.vim' " Statur bar 
Plug 'itchyny/vim-gitbranch' " lightline Branch status
Plug 'maxmellon/vim-jsx-pretty' " pretty jsx
Plug 'styled-components/vim-styled-components', { 'branch': 'main' } " Styled components HL

Plug 'jiangmiao/auto-pairs' " auto pairs ()[]{}
Plug 'alvan/vim-closetag' " close HTML tags

Plug 'sheerun/vim-polyglot' " Vim polyglot sintax for all language

Plug 'morhetz/gruvbox' " Theme gruvbox
Plug 'shinchu/lightline-gruvbox.vim' " Theme gruvbox lightline

"AutoComplete Tailwind
Plug 'iamcco/coc-tailwindcss',  {'do': 'yarn install --frozen-lockfile && yarn run build'}

"high lig errors

" Vim Script
Plug 'nvim-tree/nvim-web-devicons'

call plug#end()

lua require("configs.nvim-tree")

let g:jsx_ext_required = 1
let g:jsx_pragma_required = 1
let g:solarized_termcolors=256

colorscheme gruvbox

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly','modified'], ['kitestatus']],
      \   'right': [['filename'], ['gitbranch']]
      \ },
      \ 'component':{
      \ 'Branch':'Branch'
      \},
      \ 'component_function':{
      \  'gitbranch': 'gitbranch#name'
      \},
      \'subseparator':{
      \'left':'',
      \'right':''
      \},
      \ 'colorscheme': 'gruvbox',
      \ }

set noshowmode " stop showing mode under lightline

"Coc config"
set cmdheight=2
" Styled components config for big files (testing)

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

let mapleader = " "

nmap <Leader>s <Plug>(easymotion-s2)
nmap <Leader>nt :NvimTreeToggle<CR>
nmap <Leader>hh :hi visual ctermbg=Grey ctermfg=Blue<CR>
nmap <Leader>nh :noh<CR>

" Coc binds
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:python3_host_prog = 'D:\Programas windows\Python3.10\'

noremap <C-w>+ :resize +5<CR>
noremap <C-w>- :resize -5<CR>
noremap <C-w>< :vertical:resize -5<CR>
noremap <C-w>> :vertical:resize +5<CR>


" scrolls
nnoremap <C-j> 10<C-e>
nnoremap <C-k> 10<C-y>

set shellcmdflag=-c


" nnoremap <Leader>t :vsplit term %<CR>
"Open terminal
set splitright
function! OpenTerminal()
  "move to right buffer

  execute "normal \<C-l>"
  execute "normal \<C-l>"
  execute "normal \<C-l>"
  execute "normal \<C-l>"

  let bufNum = bufnr("%")
  let bufType = getbufvar(bufNum, "&buftype", "not found")

  if bufType == "terminal"
    " close terminal
    execute "q"
  else
    " open terminal
    execute "vsp term://bash"

    " turn off numbers
    execute "set nonu"
    execute "set nornu"

    silent au BufLeave <buffer> stopinser!
    silent au BufWinEnter,WinEnter <buffer> startinsert!

    startinsert!
  endif
endfunction

nnoremap <C-t> :call OpenTerminal()<CR>
