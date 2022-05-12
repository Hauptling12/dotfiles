let mapleader =","

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'itchyny/lightline.vim'
Plug 'https://github.com/pangloss/vim-javascript'
Plug 'dkarter/bullets.vim'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
"Plug 'preservim/nerdtree'
"Plug 'ryanoasis/vim-devicons'
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'fatih/vim-go' , { 'for': ['go', 'vim-plug'], 'tag': '*' }
Plug '~/.config/nvim/deadkeys.vim'
Plug '~/.config/nvim/ipa.vim'
"Plug 'chentau/marks.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
Plug 'bfrg/vim-cpp-modern'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'arzg/vim-swift'
Plug 'neoclide/coc-sources'
Plug 'xolox/vim-notes'
Plug 'xolox/vim-misc'
Plug 'tpope/vim-commentary'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'majutsushi/tagbar'
Plug 'alvan/vim-closetag'
"Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'vimwiki/vimwiki'
Plug 'vim-python/python-syntax'                    " Python highlighting
Plug 'mbbill/undotree'
Plug 'mattn/emmet-vim'
Plug 'rust-lang/rust.vim'

call plug#end()
"""""""""""""""""""""""
" some basics
"""""""""""""""""""""""
"set viminfo+=n$HOME/.config/nvim/viminfo
set title
set shell=$SHELL        " use current shell for shell commands
set expandtab
set backspace=indent,eol,start
silent !mkdir -p $HOME/.config/nvim/tmp/backup
silent !mkdir -p $HOME/.config/nvim/tmp/undo
if has('persistent_undo')
	set undofile
	set undodir=$HOME/.config/nvim/tmp/undo,.
endif
set backupdir=$HOME/.config/nvim/tmp/backup,.
set directory=$HOME/.config/nvim/tmp/backup,.
set clipboard+=unnamedplus
set title
set noruler
filetype plugin on
"set number relativenumber       " Display line numbers
set relativenumber       " Display line numbers
syntax on
set encoding=utf-8
set hlsearch
set incsearch
" makes clipboard save to system
" set clipboard+=unamedplus
vnoremap <C-c> "+y
set autoindent
set hidden
set splitbelow splitright
" highlight operaters
set showmatch
" Enable autocompletion:
        set wildmode=longest,list,full
" Disables automatic commenting on newline:
        autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" utils
" Check file in shellcheck:
        map <leader>s :!clear && shellcheck -x %<CR>
" Spell-check set to <leader>o, 'o' for 'orthography':
"        map <leader>o :setlocal spell! spelllang=en_us<CR>
" Save file as sudo on files that require root permission
       " cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
       cmap w!! w !doas tee > /dev/null %
" Automatically deletes all trailing whitespace and newlines at end of file on save. & reset cursor position
        autocmd BufWritePre * let currPos = getpos(".")
        autocmd BufWritePre * %s/\s\+$//e
        autocmd BufWritePre * %s/\n\+\%$//e
        autocmd BufWritePre *.[ch] %s/\%$/\r/e
        autocmd BufWritePre * cal cursor(currPos[1], currPos[2])
" Function for toggling the bottom statusbar:
let s:hidden_all = 0
map <leader>T :call ToggleHiddenAll()<CR>
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <leader>h :call ToggleHiddenAll()<CR>

" nerdtree
"let NERDTreeShowHidden=1
"autocmd VimEnter * NERDTree | wincmd p
"autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" let g:NERDTreeDirArrowExpandable = '|'
" let g:NERDTreeDirArrowCollapsible = '|'
" let NERDTreeMapOpenInTab='T'
" let NERDTreeMapOpenSplit='H'
" let NERDTreeMapOpenVSplit='V'
" let NERDTreeMinimalUI=1
" minimap
"g:minimap_block_filetypes = ['fugitive', 'nerdtree', 'tagbar', 'fzf' ]
"g:minimap_close_filetypes = ['startify', 'netrw', 'vim-plug']
"
let g:bookmark_auto_save_file = '/home/chief/.cache/vim-bookmarks'

"""
"let g:NERDCreateDefaultMappinfa = 1
"""
" marks.nvim
" rust syntax
"let g:rust_clip_command = 'xclip -selection clipboard'

" vimling:
      nm <leader><leader>d :call ToggleDeadKeys()<CR>
      imap <leader><leader>d <esc>:call ToggleDeadKeys()<CR>a
     " nm <leader><leader>i :call ToggleIPA()<CR>
     " imap <leader><leader>i <esc>:call ToggleIPA()<CR>a

"""""""""
"" markdown table
"""""
" let g:table_mode_corner='|'
" function! s:isAtStartOfLine(mapping)
"   let text_before_cursor = getline('.')[0 : col('.')-1]
"   let mapping_pattern = '\V' . escape(a:mapping, '\')
" let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
"   return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
" endfunction

" inoreabbrev <expr> <bar><bar>
 "          \ <SID>isAtStartOfLine('\|\|') ?
  "         \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
" inoreabbrev <expr> __
   "        \ <SID>isAtStartOfLine('__') ?
    "       \ '<c-o>:silent! TableModeDisable<cr>' : '__'
"noremap <LEADER>tm :TableModeToggle<CR>
"let g:table_mode_disable_mappings = 1
"let g:table_mode_cell_text_object_i_map = 'k<Bar>'
" ===
" === Bullets.vim
" ===
" Bullets.vim
let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text',
    \]

" ===
" === Undotree
" ===
"noremap L :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
let g:undotree_WindowLayout = 2
let g:undotree_DiffpanelHeight = 8
let g:undotree_SplitWidth = 24

""""""""""""""
" vimwiki
"''''
let g:vimwiki_global_ext = 0
let g:vimwiki_list = [{'path': '~/my-work/notes/ob/obsidian/', 'path_html': '~/my-work/notes/ob/obsidian/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
"""""""""""
" coc
""""
""
" snippets
""
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() :
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
                                           \"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>x  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.

nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
""""""""""""""""""""""""""
" emmet
"""::::::::::::::::::::
let g:user_emmet_mode='a'    "enable all function in all mode.
let g:user_emmet_install_global = 0
autocmd FileType xhtml,html,css EmmetInstall

"""
" closetag auto
"""
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
let g:closetag_filenames = '*.php,*.md,*.html,*.xhtml,*.jsx,*.js,*.tsx'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filenames = '*.xml,*.xhtml,*.jsx,*.js,*.tsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
let g:closetag_filetypes = 'html,xhtml,jsx,js,tsx'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filetypes = 'xml,xhtml,jsx,js,tsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1
"
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
"
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
"
let g:closetag_close_shortcut = '<leader>>'
"==
"=== netrw
"==
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 25
" Allow for netrw to be toggled
function! OpenToRight()
	:normal v
	let g:path=expand('%:p')
	execute 'q!'
	execute 'belowright vnew' g:path
	:normal <C-w>l
endfunction

function! OpenBelow()
	:normal v
	let g:path=expand('%:p')
	execute 'q!'
	execute 'belowright new' g:path
	:normal <C-w>l
endfunction

function! OpenTab()
	:normal v
	let g:path=expand('%:p')
	execute 'q!'
	execute 'tabedit' g:path
	:normal <C-w>l
endfunction

function! NetrwMappings()
		" Hack fix to make ctrl-l work properly
		noremap <buffer> <A-l> <C-w>l
		noremap <buffer> <C-l> <C-w>l
                noremap <buffer> V :call OpenToRight()<cr>
		noremap <buffer> H :call OpenBelow()<cr>
		noremap <buffer> T :call OpenTab()<cr>
endfunction

augroup netrw_mappings
		autocmd!
		autocmd filetype netrw call NetrwMappings()
augroup END
function! ToggleNetrw()
		if g:NetrwIsOpen
				let i = bufnr("$")
				while (i >= 1)
						if (getbufvar(i, "&filetype") == "netrw")
								silent exe "bwipeout " . i
						endif
						let i-=1
				endwhile
				let g:NetrwIsOpen=0
		else
				let g:NetrwIsOpen=1
				silent Lexplore
		endif
endfunction

" Check before opening buffer on any file
function! NetrwOnBufferOpen()
	if exists('b:noNetrw')
			return
	endif
	call ToggleNetrw()
endfun

	autocmd VimEnter * :call NetrwOnBufferOpen() | wincmd p
" Close Netrw if it's the only buffer open
autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" || &buftype == 'quickfix' |q|endif
" Check before opening buffer on any file
function! NetrwOnBufferOpen()
	if exists('b:noNetrw')
			return
	endif
	call ToggleNetrw()
endfun
let g:NetrwIsOpen=0
"==
"=== files
"==
" ===
" === Markdown Settings
" ===
" Snippets
" Runs a script that cleans out tex build files whenever I close out of a .tex file.
      autocmd VimLeave *.tex !texclear %
" Ensure files are read as what I want:
      let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
      autocmd BufRead,BufNewFile ~/.calcurse/notes/* set filetype=markdown
      autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
      autocmd BufRead,BufNewFile *.tex set filetype=tex

""
" modules
""
augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank{higroup="YankColor", timeout=300, on_visual=false}
augroup END
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
augroup END

" cursor preview
"set cursorline
set cursorcolumn
"""""""""""""""""
" keybindings remaped
"""""""""""""""""
" Faster in-line navigation
"noremap W 5w
noremap B 5b

"nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :call ToggleNetrw()<CR>
" nnoremap <C-t> :NERDTreeToggle<CR>
"nnoremap <C-f> :NERDTreeFind<CR>
" Shortcutting split navigation, saving a keypress:
      map <C-h> <C-w>h
      map <C-j> <C-w>j
      map <C-k> <C-w>k
      map <C-l> <C-w>l
      " Make adjusing split sizes a bit more friendly
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

" Change 2 split windows from vert to horiz or horiz to vert
map <Leader>th <C-w>t<C-w>H
map <Leader>tk <C-w>t<C-w>K
" Removes pipes | that act as seperators on splits
set fillchars+=vert::
" emmet shortcuts
"" files
" make Y to copy till the end of the line
"nnoremap Y y$

" Copy to system clipboard
vnoremap Y "+y
" noremap <C-q> :qa<CR>
"noremap S :w<CR>
noremap q :wq

" Open the vimrc file anytime
"noremap <LEADER>rc :e $HOME/.config/nvim/init.vim<CR>
" ===
" === Tab management
" ===
" Create a new tab with tu
noremap tu :tabe<CR>
noremap tU :tab split<CR>
" Move around tabs with tn and ti
noremap tn :-tabnext<CR>
noremap ti :+tabnext<CR>
" Move the tabs with tmn and tmi
noremap tmn :-tabmove<CR>
noremap tmi :+tabmove<CR>
" Spelling Check with <space>sc
noremap <LEADER>sc :setlocal spell spelllang=en_au!<CR>

inoremap ;g <Esc>/<++><Enter>"_c4l
"inoremap ;g <++>
" css
autocmd FileType css map <leader>lib i@import url('https://unpkg.com/boxicons@2.1.1/css/boxicons.min.css');<Enter>
autocmd FileType css map <leader>lif i@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/css/all.min.css');<Enter>
""" html
autocmd FileType html map <leader>ljq i<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script><Enter>
autocmd FileType html,markdown map <leader>le i<em></em><CR>
autocmd FileType markdown,html map <leader>l1 <h1></h2><Esc>FeT>i
autocmd FileType markdown,html map <leader>l2 <h2></h2><Esc>FeT>i
autocmd FileType markdown,html map <leader>l3 <h3></h3><Esc>FeT>i
autocmd FileType markdown,html map <leader>l4 <h4></h4><Esc>FeT>i
autocmd FileType markdown,html map <leader>l5 <h5></h5><Esc>FeT>i
autocmd FileType markdown,html map <leader>l6 <h6></h6><Esc>FeT>i
autocmd FileType markdown,html map <leader>ldi <div></div><Esc>FeT>i
autocmd FileType html map <leader>lll <li></li><Esc>FeT>i
autocmd FileType html map <leader>lp <p></p><Esc>FeT>i
autocmd FileType html map <leader>lb <b></b><Esc>FeT>i
autocmd FileType html map <leader>lco <code></code><Esc>FeT>i
autocmd FileType html map <leader>lq <q></q><Esc>FeT>i
autocmd FileType html map <leader>lal <a href=""></a><Esc>FeT>i
autocmd FileType html map <leader>lar <article><Enter></article><Esc>FeT>i
autocmd FileType html inoremap ;tr <tr></tr><Esc>FeT>i
autocmd FileType html inoremap ;tcg <colgroup></colgroup><Esc>FeT>i
autocmd FileType html inoremap ;tcn <col></col><Esc>FeT>i
autocmd FileType html inoremap ;ta <table><Enter></table>
autocmd FileType html map <leader>lif <iframe></iframe><Space><Space><++><Esc>FeT>i
autocmd FileType html map <leader>lim <img src="" alt=""><Enter><++><Esc>FeT>i
autocmd FileType html map <leader>lin <i></i><Space><Space><++><Esc>FeT>i
autocmd FileType html map <leader>lsb <strong></strong><Space><Space><++><Esc>FeT>i
autocmd FileType html map <leader>lsub <sub></sub><Space><Space><++><Esc>FeT>i
autocmd FileType html map <leader>lsup <sup></sup><Space><Space><++><Esc>FeT>i
autocmd FileType html map <leader>lstr <s></s><Space><Space><++><Esc>FeT>i
autocmd FileType html map <leader>lsp <span></span><Esc>FeT>i
autocmd FileType html map <leader>lsm <small></small><Esc>FeT>i
autocmd FileType html map <leader>lscr <script></script><Esc>FeT>i
autocmd FileType html map <leader>lsa <samp></samp><Esc>FeT>i
autocmd FileType html map <leader>llc i<link rel="stylesheet" href=""><Esc>hhi
""" markdown
autocmd FileType markdown inoremap ;l <li></li><Space><Space><Enter><++><Esc>FeT>i
autocmd FileType markdown inoremap ;p <p></p><Space><Space><++><Esc>FeT>i
autocmd FileType markdown inoremap ;o <ol></ol><Enter><Enter><++>
autocmd FileType markdown inoremap ;b <b></b><Space><Space><++><Esc>FeT>i
autocmd FileType markdown inoremap ;u <ul></ul><Enter><Enter><++>
autocmd FileType markdown inoremap ;co <code></code><Space><Space><Esc>FeT>i
autocmd FileType markdown inoremap ;q <q></q><Space><Space><++><Esc>FeT>i
autocmd FileType markdown inoremap ;h <a href=""></a><Space><Space><++><Esc>FeT>i
autocmd FileType markdown inoremap ;a <article><Enter></article><Enter><++>FeT>i
autocmd FileType markdown inoremap ;tr <tr></tr><Space><Space><++><Esc>FeT>i
autocmd FileType markdown inoremap ;im <img src="" alt=""><Enter><++><Esc>FeT>i
autocmd FileType markdown inoremap ;in <i></i><Space><Space><++><Esc>FeT>i
autocmd FileType markdown inoremap ;sb <strong></strong><Space><Space><++><Esc>FeT>i
autocmd FileType markdown inoremap ;sub <sub></sub><Space><Space><++><Esc>FeT>i
autocmd FileType markdown inoremap ;sup <sup></sup><Space><Space><++><Esc>FeT>i
autocmd FileType markdown inoremap ;str <s></s><Space><Space><++><Esc>FeT>i
autocmd FileType markdown inoremap ;sp <span></span><Space><Space><++><Esc>FeT>i
autocmd FileType markdown inoremap ;sm <small></small><Space><Space><++><Esc>FeT>i
autocmd FileType markdown inoremap ;sa <samp></samp><Space><Space><++><Esc>FeT>i
"""" uny
autocmd FileType markdown inoremap ;wf <Enter>#//22<Enter>Wilf:<Enter><Enter>Walt:<Enter>
autocmd FileType markdown inoremap ,1 #<Space><CR><CR><++><Esc>
autocmd FileType markdown inoremap ,2 ##<Space><CR><CR><++><Esc>
autocmd FileType markdown inoremap ,3 ###<Space><CR><CR><++><Esc>
autocmd FileType markdown inoremap ,4 ####<Space><CR><CR><++><Esc>
autocmd FileType markdown inoremap ,5 #####<Space><CR><CR><++><Esc>
autocmd FileType markdown inoremap ,ht ```html<Enter><Enter>```<CR><++><Esc>kki
" vim
autocmd FileType vim map <leader>la iautocmd FileType
autocmd FileType vim map <leader>lm imap <lt>leader>
autocmd FileType vim map <leader>lch iautocmd FileType html map <lt>leader>
autocmd FileType vim map <leader>lch iautocmd FileType python map <lt>leader>
""" bash
map <leader>bs ggO#!/bin/sh<CR><CR>
map <leader>p3 ggO#!/bin/python3<CR><CR>
map <leader>p1 ggO#!/bin/python<CR><CR>
map <leader>bb ggO#!/bin/bash<CR><CR>
map <leader>bz ggO#!/bin/zsh
map <leader>bc icase $ in<Enter><enter>esac<Esc>ki
" c
autocmd FileType c map <leader>lst i#include <stdio.h><Enter>int main() {<Enter><Enter>}<Esc>ki
autocmd FileType c map <leader>lmm i#include <math.h><Enter><Esc>i
autocmd FileType c map <leader>lmt i#include <time.h><Enter><Esc>i
autocmd FileType c map <leader>lp iprintf();<Esc>hhi
autocmd FileType c,cpp map <leader>lr0 ireturn 0;
autocmd FileType c map <leader>lsy isystem("");<Esc>hhi
autocmd FileType c map <leader>lar iint main (int argc, char *argv[])<Enter>{<Enter>  char *argument;<Enter>}
" c++
autocmd FileType cpp map <leader>lco icout <<
autocmd FileType cpp map <leader>lci icin >>
" python
autocmd FileType python map <leader>lma idef main():<Enter><Enter>if __name__ == "__main__":<Enter>main()
autocmd FileType python map <leader>lin iinput("")<Esc>hhi
autocmd FileType python map <leader>lda idatetime.now().strftime('%Y-%m-%d %H:%M:%S')<Enter>
autocmd FileType python map <leader>lcl ios.system('clear')<Enter>
autocmd FileType python map <leader>lii iint(input(""))<Esc>hhi
" auto it
autocmd FileType autoit map <leader>lex iRun("")<Esc>hi
" haskell
autocmd FileType haskell map <leader>lsp i, ("", spawn "")
" powershell
autocmd FileType ps1 map <leader>lki iGet-Process  \| Stop-Process<Esc>14hi
autocmd FileType ps1 map <leader>lpo ipowercfg.exe -SETACTIVE
autocmd FileType ps1 map <leader>lvo i$obj = new-object -com wscript.shell<Enter>$obj.SendKeys([char]173)
autocmd FileType ps1 map <leader>lgne iNew-Object system.Windows.Forms.Button
autocmd FileType ps1 map <leader>lsip iSet-ItemProperty -Path
autocmd FileType ps1 map <leader>lds iDisable-ScheduledTask -TaskName
autocmd FileType ps1 map <leader>lsp iStop-Process -Name
autocmd FileType ps1 map <leader>lri iRemove-ItemProperty -Path
" js
autocmd FileType javascript map <leader>li idocument.getElementById('')<Esc>hi
autocmd FileType javascript map <leader>lur iurlParams.get('');<Esc>hhi
autocmd FileType javascript map <leader>lth ilet hour = time.getHours();
autocmd FileType javascript map <leader>ltm ilet min = time.getMinutes();
autocmd FileType javascript map <leader>lts ilet sec = time.getSeconds();
map <leader>i :setlocal autoindent<CR>
map <leader>I :setlocal noautoindent<CR>

"""""""""""""""""""""""""""""""""
" => Status Line
"""""""""""""""""""""""""""""""""
" The lightline.vim theme
let g:lightline = {
      \ 'colorscheme': 'darcula',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [  'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
" Always show statusline
set laststatus=2

" Uncomment to prevent non-normal modes showing in powerline and below powerline.
set noshowmode

" mutt
autocmd BufRead,BufNewFile /tmp/neomutt* :call ToggleHiddenAll()
""""""""""""""""""""""""""""""
" => Other Stuff
""""""""""""""""""""""""""""""
let g:python_highlight_all = 1

set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
" markdown previewer
au BufWriteCmd,BufRead *.md :w | !cat % > /tmp/vim-mdpre.md
" Enable and disable auto comment
map <leader>c :setlocal formatoptions-=cro<CR>
map <leader>C :setlocal formatoptions=cro<CR>
nnoremap <leader>w :w<CR>
" Replace all is aliased to S.
      nnoremap S :%s//g<Left><Left>
"-------- Auto commands -------"
"automatically source the Vimrc file on save.
augroup autosourcing
   autocmd!
   autocmd BufWritePost .vimrc source %
augroup END
" Fix indenting visual block
vmap < <gv
vmap > >gv
nnoremap <A-g> :GFiles<CR>
nnoremap <A-z> :Files<CR>
let g:fzf_preview_window = 'right:60%'
"" Default key bindings
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-h': 'split',
            \ 'ctrl-v': 'vsplit' }