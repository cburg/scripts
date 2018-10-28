"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Chris Burgess
" Vim Config File
" Last Edited 14 November 2013
"             10 January  2014
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call pathogen#infect()




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visuals
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set background=dark 
set ruler
set number
set colorcolumn=81

" Set the Terminal Title
set title
set titlestring=%t\ %y\ %r\ %m     "<filename> <filetype> <readonly> <modified>
set titleold=Termial



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Navigating and Editing
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set pastetoggle=<F2>
set mouse=a

" Keybindings to navigate windows: up, down, left, right (respectively)
map <C-Up> <C-w>k
map <C-Down> <C-w>j
map <C-Left> <C-w>h
map <C-Right> <C-w>l


" Keybindings for buffers: navigate (bn, bp); list (ls); open all (ball);
map <F9> :bn <CR>
map <F10> :bp <CR>
map <F11> :ls <CR>
map <F12> :ball <CR>

map <C-k> :bn <CR>
map <C-j> :bp <CR>

" Keybindings to navigate between open tabs: cycle left, right
map <C-h> :tabp <CR>
map <C-l> :tabn <CR>



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text Formatting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shiftwidth=4
set tabstop=4
set softtabstop=4
set autoindent
set cindent
set expandtab



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Searching
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ignorecase
set smartcase
set hlsearch



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Printing (Does not currently work...)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set pdev=pdf
set printoptions=paper:A4,syntax:y,wrap:y,duplex:long




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autogroups and Autocommands 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType make setlocal noexpandtab     " Don't expand tabs for Makefiles


