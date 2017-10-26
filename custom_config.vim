let mapleader = ","

" enter the current millenium 
set nocompatible

" enable syntax and plugins (for netrw)
syntax enable 
filetype plugin on 

" FINDING FILES:
set path+=**
set wildmenu

" behavior(all runtime snippets are disabled).
let g:neosnippet#disable_runtime_snippets = {
\   '_' : 1,
\ }

" disable arrows
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" disable mouse
set mouse=
map <ScrollWheelUp> <Nop>
map <S-ScrollWhellUp> <Nop>
map <ScrollWheelDown> <Nop>
map <S-ScrollWheelDown> <Nop>

" tagbar
nmap <Leader>tb :TagbarOpenAutoClose<CR>

au FileType go map <F6> :GoRename<CR>

let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1

set autowrite

let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_build_constraints = 1

let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
