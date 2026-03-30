"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    " Enable true color support
    set termguicolors
  endif
endif

" Enable syntax highlighting
syntax on

" customize the colors on `autocmd ColorScheme`, which is automatically
" triggered whenever you change color schemes
function! s:tweak_molokai_colors()
  " Your molokai customizations
  hi ActiveWindow guibg=#17252c
  hi InactiveWindow guibg=#0D1B22
endfunction
autocmd! ColorScheme molokai call s:tweak_molokai_colors()

" Syntax highlighting color scheme
colorscheme molokai

" Vim airline theme
let g:airline_theme='molokai'

" Don't dispay mode in command line (airilne already shows it)
set noshowmode

" Disable mouse
set mouse=

" Set floating window to be slightly transparent
"set winblend=10

" ================ Highlight active window ======================

" Background colors for active vs inactive windows
hi ActiveWindow guibg=#17252c
hi InactiveWindow guibg=#0D1B22

" Call method on window enter
augroup WindowManagement
  autocmd!
  autocmd WinEnter * call Handle_Win_Enter()
augroup END

" Change highlight group of active/inactive windows
function! Handle_Win_Enter()
  setlocal winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow
endfunction
