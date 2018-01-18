let mapleader = ","

" enter the current millenium 
set nocompatible

command! MakeTags !ctags -R .

colorscheme gruvbox

cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

" enable syntax and plugins (for netrw)
syntax enable 
filetype plugin on 

" FINDING FILES:
set path+=**
set wildmenu

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
nmap <Leader>tt :TagbarOpenAutoClose<CR>

au FileType go map <F6> :GoRename<CR>

let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1

set autowrite

let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_build_constraints = 1

