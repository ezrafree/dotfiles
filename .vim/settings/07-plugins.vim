" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" ========== NERDtree ========== "

" NERDTree is a file system explorer for the Vim editor
" Note: keymapped to be opened with Ctrl-f
Plug 'preservim/nerdtree' |
  \ Plug 'Xuyuanp/nerdtree-git-plugin'

" ========== Text editing ========== "

" Trailing whitespace highlighting & automatic fixing
Plug 'ntpeters/vim-better-whitespace'

" Easily add/change/delete surrounding quotes, brackets, tags
Plug 'tpope/vim-surround'

" Comment/uncomment lines with gcc (line) or gc (motion/visual)
Plug 'numToStr/Comment.nvim'

" Goyo is a distraction-free writing mode for Vim
Plug 'junegunn/goyo.vim'

" LimeLight is a plugin for Vim to highlight the current paragraph
Plug 'junegunn/limelight.vim'

" ========== Syntax highlighting ========== "

" Vim Polyglot is a collection of syntax highlighting language packs for Vim
Plug 'sheerun/vim-polyglot'

" ========== Git ========== "

" Git plugin for Vim (vim-fugitive must be loaded before vim-airline)
Plug 'tpope/vim-fugitive'

" Customized vim status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Vim-gitgutter is a Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks
Plug 'airblade/vim-gitgutter'

" Vim-extradite is a git log/history viewer that extends vim-fugitive's :Glog
Plug 'int3/vim-extradite'

" ========== Markdown ========== "

" Vim Markdown
Plug 'godlygeek/tabular' " tabular plugin is used to format tables
Plug 'elzr/vim-json' " JSON front matter highlight plugin
Plug 'plasticboy/vim-markdown' " Base vim-markdown plugin
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' } " Markdown preview in browser

" ========== Initialize plugins ========== "

" Initialize plugin system
call plug#end()

lua require('Comment').setup()
