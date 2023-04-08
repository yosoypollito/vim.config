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

set hlsearch " hightligh matches"
set incsearch " incremental searching"
set ignorecase " searches are case insensitive ..."
set smartcase " ... unless they contain at least one capital letter"

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

"comenter
Plug 'preservim/nerdcommenter'

call plug#end()

lua require("configs.nvim-tree")

let g:jsx_ext_required = 1
let g:jsx_pragma_required = 1
let g:solarized_termcolors=256

let g:gruvbox_contrast_dark = "hard"


colorscheme gruvbox

let g:lightline = {
                  \ 'active': {
                  \   'left': [ ['mode', 'paste'],[], ['readonly', 'modified']],
                  \   'right': [['lineinfo','filename'],[],['gitbranch']]
                  \ },
                  \ 'component':{
                  \ 'lineinfo': '%3l:%-2v%<',
                  \   'charvaluehex': '0x%B'
                  \},
                  \ 'component_function':{
                  \  'gitbranch': 'GitBranch',
                  \},
                  \'subseparator':{
                  \'left':'',
                  \'right':''
                  \},
                  \ 'colorscheme': 'gruvbox',
                  \ }

function GitBranch()
      return gitbranch#name() .. " "
endfunction

set noshowmode " stop showing mode under lightline

"Coc config"
set cmdheight=2
" Styled components config for big files (testing)

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

let mapleader = " "
" move lines -> ALT-j ALT-K
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
"<leader>c<space> -> comment

nnoremap <silent>J 10<C-e>
nnoremap <silent>K 10<C-y>

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

" for comment
filetype plugin on

noremap <C-w>+ :resize +5<CR>
noremap <C-w>- :resize -5<CR>
noremap <C-w>< :vertical:resize -5<CR>
noremap <C-w>> :vertical:resize +5<CR>


set splitright
set shellcmdflag=-c
"Open terminal
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

            " set maps

            execute "tnoremap <buffer> <C-h> <C-\\><C-n><C-w><C-h>"

            execute "tnoremap <buffer> <C-t> <C-\\><C-n>:q<CR>"
            startinsert!
      endif
endfunction

nnoremap <C-t> :call OpenTerminal()<CR>
