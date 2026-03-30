" Plugins configurations

" =============== nerdtree-git-plugin =============== "

let g:NERDTreeGitStatusUseNerdFonts = 1

" =============== goyo =============== "

let g:limelight_conceal_ctermfg = 240
let g:limelight_conceal_guifg = '#555555'

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" =============== vim-better-whitespace =============== "

" enable highlighting and stripping whitespace on save

let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:better_whitespace_ctermcolor='darkred'

" =============== gitgutter =============== "

let g:gitgutter_sign_added = '▐'
let g:gitgutter_sign_modified = '▐'
let g:gitgutter_sign_removed = '▐'
let g:gitgutter_sign_modified_removed = '∙'
"let g:gitgutter_sign_removed_first_line = '^'
"let g:gitgutter_sign_removed_above_and_below = '{'

" =============== markdown-preview =============== "

let g:mkdp_markdown_css = expand('~/.vim/settings/markdown-preview.css')

" =============== vim-markdown =============== "

" disable header folding
let g:vim_markdown_folding_disabled = 1

" do not use conceal feature, the implementation is not so good
let g:vim_markdown_conceal = 0

" disable math tex conceal feature
let g:tex_conceal = ""
let g:vim_markdown_math = 1

" support front matter of various format
let g:vim_markdown_frontmatter = 1  " for YAML format
let g:vim_markdown_toml_frontmatter = 1  " for TOML format
let g:vim_markdown_json_frontmatter = 1  " for JSON format

" =============== Vim airline =============== "

" Wrap in try/catch to avoid errors on initial install before plugin is available
try
" Enable extensions
let g:airline_extensions = ['branch', 'hunks']

" Update section z to just have line number
"let g:airline_section_z = airline#section#create(['linenr'])

" Do not draw separators for empty sections (only for the active window) >
let g:airline_skip_empty_sections = 1

" Smartly uniquify buffers names with similar filename, suppressing common parts of paths.
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Custom setup that removes filetype/whitespace from default vim airline bar
let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'z', 'warning', 'error']]

" Customize vim airline per filetype
" 'nerdtree'  - Hide nerdtree status line
" 'list'      - Only show file type plus current line number out of total
let g:airline_filetype_overrides = {
  \ 'nerdtree': [ get(g:, 'NERDTreeStatusline', ''), '' ],
  \ 'list': [ '%y', '%l/%L'],
  \ }

" Enable powerline fonts
let g:airline_powerline_fonts = 1

" Enable caching of syntax highlighting groups
let g:airline_highlighting_cache = 1

" Define custom airline symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
"let g:airline_symbols.linenr = ''

" Don't show git changes to current file in airline
let g:airline#extensions#hunks#enabled=1

catch
  echo 'Airline not installed. It should work after running :PlugInstall'
endtry
