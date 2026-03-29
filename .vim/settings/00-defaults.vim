let mapleader = ","             " Set leader key to comma

set guicursor=a:ver25-blinkon1  " Set blinking, vertical bar cursor
set ruler                       " Show the line and column numbers of the cursor.
set textwidth=0                 " Hard-wrap long lines as you type them.
set linespace=0                 " Set line-spacing to minimum.
"set number                      " Line numbers are good
set visualbell                  " No sounds
set autoread                    " Reload files changed outside vim
set backspace=indent,eol,start  " Allow backspace in insert mode
set history=1000                " Store lots of :cmdline history
set showcmd                     " Show incomplete cmds down the bottom
set cursorline                  " Highlight current cursor line
set hidden                      " Hide buffers instead of closing them
set noshowcmd                   " Don't show last command
set scrolloff=5                 " Keep 5 lines below and above the cursor

" unset the 'last search pattern' register by hitting return
nnoremap <CR> :noh<CR><CR>
