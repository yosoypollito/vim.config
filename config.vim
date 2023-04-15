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

set nobackup
set nowritebackup

set cursorline " background for current line

set hlsearch " hightligh matches"
set incsearch " incremental searching"
set ignorecase " searches are case insensitive ..."
set smartcase " ... unless they contain at least one capital letter"

set termguicolors " needed for colorizer codes

" Styled components config for big files (testing)

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" move lines -> ALT-j ALT-K
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" coc servers
let g:coc_global_extensions = [ 'coc-tsserver', 'coc-json', 'coc-eslint', 'coc-prettier', 'coc-css', 'coc-html', 'coc-react-refactor']
set updatetime=300

" create component with coc-react-refactor
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
endfunction                              

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
