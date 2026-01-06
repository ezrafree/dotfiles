" Keyboard shortcut mappings

" =============== general shortcuts =============== "

" Move between open buffers with Ctrl-n and Ctrl-p
nmap <C-n> :bnext<CR>
nmap <C-p> :bprev<CR>

" map Ctrl-shift-left and Ctrl-shift-right to switch tabs
map <C-S-left> :tabprevious<CR>
map <C-S-right> :tabnext<CR>

" move cursor across wrapped lines
nnoremap <expr> <Up> v:count ? 'k' : 'gk'
nnoremap <expr> <Down> v:count ? 'j' : 'gj'
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'j' : 'gj'

" =============== nerdtree shortcuts =============== "

" Open NERDtree with Ctrl-f
map <C-f> :NERDTreeToggle<CR>

nnoremap <leader>n :NERDTreeFocus<CR>

" =============== search shortcuts =============== "

"   <leader>h - Find and replace
"   <leader>/ - Clear highlighted search terms while preserving history
map <leader>h :%s///<left><left>
nmap <silent> <leader>/ :nohlsearch<CR>

" =============== goyo shortcuts =============== "

" Goyo is a distraction-free writing mode for Vim

" map <leader>f to the :Goyo command
autocmd FileType markdown nnoremap <buffer> <leader>f :Goyo<CR>

" configure a :Focus command to trigger :Goyo in markdown files
autocmd FileType markdown command Focus :Goyo

" =============== markdown-preview shortcuts =============== "

" map <leader>m to the :MarkdownPreview command
nnoremap <leader>m :MarkdownPreview<CR>

" =============== git gutter shortcuts =============== "

nmap \g :GitGutterToggle<CR>
