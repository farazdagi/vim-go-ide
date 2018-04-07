" Don't request terminal version string (for xterm)
set t_RV=

" Switch between the last two files
nnoremap <leader><leader> <C-^>

" Switch between the last two files
nnoremap <leader><leader> <C-^>

" Allow to copy/paste between VIM instances
"copy the current visual selection to ~/.vbuf
vmap <leader>y :w! ~/.vbuf<cr>

"copy the current line to the buffer file if no visual selection
nmap <leader>y :.w! ~/.vbuf<cr>

"paste the contents of the buffer file
nmap <leader>p :r ~/.vbuf<cr>

" map CTRL-L to piece-wise copying of the line above the current one
imap <C-L> @@@<esc>hhkywjl?@@@<CR>P/@@@<cr>3s

" turn off search highlighting (type <leader>n to de-select everything)
nmap <silent> <leader>n :silent :nohlsearch<cr>

" Make sure that CTRL-A (used by gnu screen) is redefined
noremap <leader>inc <C-A>

" Make Ctrl-H J K L work for tmux pane navigation
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
