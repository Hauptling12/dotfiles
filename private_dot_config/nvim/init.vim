" {{{ plugins
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
"Plug 'itchyny/lightline.vim'
Plug 'https://github.com/pangloss/vim-javascript'
Plug 'dkarter/bullets.vim'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
Plug 'fatih/vim-go' , { 'for': ['go', 'vim-plug'], 'tag': '*' }
Plug '~/.config/nvim/deadkeys.vim'
Plug '~/.config/nvim/ipa.vim'
"Plug 'chentau/marks.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
Plug 'bfrg/vim-cpp-modern'
Plug 'https://github.com/honza/vim-snippets'
"Plug 'MattesGroeger/vim-bookmarks'
"Plug 'arzg/vim-swift'
Plug 'neoclide/coc-sources'
"Plug 'xolox/vim-notes'
"Plug 'xolox/vim-misc'
Plug 'tpope/vim-commentary'
Plug 'https://github.com/tpope/vim-surround'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'majutsushi/tagbar'
Plug 'alvan/vim-closetag'
Plug 'preservim/vim-markdown'
Plug 'vimwiki/vimwiki'
Plug 'vim-python/python-syntax'
Plug 'mbbill/undotree'
Plug 'mattn/emmet-vim'
Plug 'rust-lang/rust.vim'
call plug#end()
"}}}
" {{{General
set history=700
filetype plugin on
filetype indent on
let mapleader =","
nmap <leader>w :w!<cr>
"}}}
" {{{vim userinterface
set title
set numberwidth=3
set splitbelow splitright
set noruler
set noshowmode
set relativenumber       " Display line numbers
set hlsearch
set incsearch
set smartcase
set ignorecase
" Enable autocompletion:
set wildmode=longest,list,full
" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
set encoding=utf-8
set autoindent
set hidden
"set cursorline
set cursorcolumn
" highlight operaters
set showmatch
" tab
set shiftwidth=4
set expandtab
set backspace=indent,eol,start
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
augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank{higroup="YankColor", timeout=300, on_visual=false}
augroup END
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
augroup END
nnoremap <leader>h :call ToggleHiddenAll()<CR>
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
" Removes pipes | that act as seperators on splits
set fillchars+=vert::
set foldmethod=marker
" Auto-resize splits when Vim gets resized.
autocmd VimResized * wincmd =
"}}}
"{{{Colors and Fonts
syntax on
hi Pmenu ctermbg=black ctermfg=white
hi netrwDir ctermbg=none ctermfg=gray
hi clear SpellBad
hi SpellBad cterm=underline
" hi SpellBad cterm=underline ctermfg=203 guifg=#ff5f5f
" hi SpellLocal cterm=underline ctermfg=203 guifg=#ff5f5f
" hi SpellRare cterm=underline ctermfg=203 guifg=#ff5f5f
" hi SpellCap cterm=underline ctermfg=203 guifg=#ff5f5f
highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace guibg=red
hi WinSeparator ctermbg=DarkBlue guibg=DarkBlue
"}}}
"{{{Files
"set viminfo+=n$HOME/.config/nvim/viminfo
" Edit Vim config file in a new tab.
map <Leader>ev :tabnew $MYVIMRC<CR>
" Source Vim config file.
map <Leader>sv :source $MYVIMRC<CR>
autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig

autocmd BufRead,BufNewFile vifmrc set filetype=vifm
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile .bashrc set filetype=bash
autocmd BufRead,BufNewFile .zshrc set filetype=sh
autocmd BufRead,BufNewFile *.tex set filetype=tex
silent !mkdir -p $HOME/.config/nvim/tmp/backup
silent !mkdir -p $HOME/.config/nvim/tmp/undo
if has('persistent_undo')
	set undofile
	set undodir=$HOME/.config/nvim/tmp/undo,.
endif
set backupdir=$HOME/.config/nvim/tmp/backup,.
set directory=$HOME/.config/nvim/tmp/backup,.
" Runs a script that cleans out tex build files whenever I close out of a .tex file.
      autocmd VimLeave *.tex !texclear %
"automatically source the Vimrc file on save.
" augroup autosourcing
   " autocmd!
   " autocmd BufWritePost init.vim source %
" augroup END
" Automatically deletes all trailing whitespace and newlines at end of file on save. & reset cursor position
        autocmd BufWritePre * let currPos = getpos(".")
        autocmd BufWritePre * %s/\s\+$//e
        autocmd BufWritePre * %s/\n\+\%$//e
        autocmd BufWritePre *.[ch] %s/\%$/\r/e
        autocmd BufWritePre * cal cursor(currPos[1], currPos[2])
" }}}
"{{{Moving around
set matchpairs+=<:> " Use % to jump between pairs
nnoremap <C-Up> :m .-2<CR>==
nnoremap <C-Down> :m .+1<CR>==
vnoremap <C-Up> :m '<-2<CR>gv=gv
vnoremap <C-Down> :m '>+1<CR>gv=gv
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
"Make adjusing split sizes a bit more friendly
noremap <silent> <S-Left> :vertical resize +3<CR>
noremap <silent> <S-Right> :vertical resize -3<CR>
noremap <silent> <S-Up> :resize +3<CR>
noremap <silent> <S-Down> :resize -3<CR>
" Change 2 split windows from vert to horiz or horiz to vert
map <Leader>th <C-w>t<C-w>H
map <Leader>tk <C-w>t<C-w>K
"Tab management
"new tab with tu
noremap tu :tabe<CR>
noremap tU :tab split<CR>
" Move around tabs with tn and ti
noremap tn :-tabnext<CR>
noremap ti :+tabnext<CR>
"Move tabs with tmn and tmi
noremap tmn :-tabmove<CR>
noremap tmi :+tabmove<CR>
nnoremap <C-A-j> :m .+1<CR>==
nnoremap <C-A-k> :m .-2<CR>==
vnoremap <C-A-j> :m '>+1<CR>gv=gv
vnoremap <C-A-k> :m '<-2<CR>gv=gv
vmap < <gv
vmap > >gv
"noremap W 5w
noremap B 5b
map <leader>i :setlocal autoindent<CR>
map <leader>I :setlocal noautoindent<CR>
" Enable and disable auto comment
map <leader>c :setlocal formatoptions-=cro<CR>
map <leader>C :setlocal formatoptions=cro<CR>
nnoremap <up> :echoerr "Don't use arrow keys, use H, J, K, L instead!"<CR>
nnoremap <down> :echoerr "Don't use arrow keys, use H, J, K, L instead!"<CR>
nnoremap <right> :echoerr "Don't use arrow keys, use H, J, K, L instead!"<CR>
nnoremap <left> :echoerr "Don't use arrow keys, use H, J, K, L instead!"<CR>
"}}}
"{{{tabs
autocmd FileType json setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType c,cpp setlocal tabstop=4 shiftwidth=4
autocmd FileType java setlocal shiftwidth=2 softtabstop=2
autocmd FileType markdown setlocal shiftwidth=2 softtabstop=2
autocmd FileType swift setlocal shiftwidth=4 softtabstop=4
autocmd FileType typescript setlocal tabstop=2 softtabstop=2 shiftwidth=2
"}}}
"{{{statusline
" hi StatusLine ctermfg=236 ctermbg=236 guifg=#323232 guibg=#323232
" hi StatusLineNC ctermfg=236 ctermbg=236 guifg=#323232 guibg=#323232
"new in vim 7.4.1042
let g:word_count=wordcount().words
function WordCount()
    if has_key(wordcount(),'visual_words')
        let g:word_count=wordcount().visual_words."/".wordcount().words " count selected words
    else
        let g:word_count=wordcount().cursor_words."/".wordcount().words " or shows words 'so far'
    endif
    return g:word_count
endfunction
" Status Line Custom
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ '^V' : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '^S' : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

set statusline=
set statusline+=%1*\ %n
set statusline+=%2*\ │
set statusline+=%5*\ %{toupper(g:currentmode[mode()])}\  " The current mode
set statusline+=%2*\ │
set statusline+=%2*\ %t
set statusline+=%2*\ │
set statusline+=%{&modified?'+\ ':''}
set statusline+=%2*\ \ %r
set statusline+=%#warningmsg# "display a warning if file encoding isnt utf-8
set statusline+=%=                                       " Right Side
set statusline+=%2*\ %{&ff}
set statusline+=%2*\ │
set statusline+=%2*\ %{''.(&fenc!=''?&fenc:&enc).''}      "Encoding
set statusline+=%2*\ │
set statusline+=%2*\ %y\                                  "FileType
set statusline+=%2*\ │
set statusline+=%2*\ (%03p%%)\             "Rownumber/total (%)
set statusline+=%2*\ │
set statusline+=%2*\ \ %2l:%c\           " Line number / total lines, percentage of document
set statusline+=%2*\ │
set statusline+=%2*\ \ %l
set statusline+=%2*\ │
set statusline+=\ w:%{WordCount()},
hi User5 ctermfg=235 ctermbg=104 guifg=#2b2b2b guibg=#9876aa
au InsertEnter * hi User5 ctermbg=1 guibg=DarkRed
au InsertLeave * hi User5 ctermbg=104 guibg=#9876aa
 hi User2 ctermfg=104  guifg=#9876aa
" hi User4 guifg=#112605  guibg=#aefe7B
"}}}
if exists('$SHELL')
        set shell=$SHELL
else
        set shell=/bin/zsh
endif
" set clipboard+=unnamedplus
" makes clipboard save to system
" Prevent x from overriding what's in the clipboard.
noremap x "_x
noremap X "_x
" Save file as sudo on files that require root permission
       " cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
       cmap w!! w !doas tee > /dev/null %
"{{{ plugin conf
" rust syntax
"let g:rust_clip_command = 'xclip -selection clipboard'

"{{{vimling:
      nm <leader><leader>d :call ToggleDeadKeys()<CR>
      imap <leader><leader>d <esc>:call ToggleDeadKeys()<CR>a
     " nm <leader><leader>i :call ToggleIPA()<CR>
     " imap <leader><leader>i <esc>:call ToggleIPA()<CR>a
"}}}
"""""""""
"" markdown table
"""""
"let g:table_mode_disable_mappings = 1
"let g:table_mode_cell_text_object_i_map = 'k<Bar>'
"{{{Bullets.vim
let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text',
    \]
"}}}
"{{{status line
" let g:lightline = {
"       \ 'colorscheme': 'darcula',
"       \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ],
"       \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ],
      " \   'right': [ [ 'fileformat', 'fileencoding', 'filetype', 'percent', 'lineinfo', 'line' ],
      " \              [ 'bufnum' ] ],
      " \ },
      " \ 'component_function': {
      " \   'fileformat': 'LightlineFileformat',
      " \   'filetype': 'LightlineFiletype',
" \   'cocstatus': 'coc#status'
      " \ },
      " \ }
" function! LightlineFileformat()
  " return winwidth(0) > 70 ? &fileformat : ''
" endfunction

" function! LightlineFiletype()
  " return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
" endfunction
" " Always show statusline
" set laststatus=2
"}}}
" {{{Undotree
"noremap L :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
let g:undotree_WindowLayout = 2
let g:undotree_DiffpanelHeight = 8
let g:undotree_SplitWidth = 24
"}}}
" {{{vimwiki
"''''
let g:vimwiki_global_ext = 0
let g:vimwiki_list = [{'path': '~/my-work/notes/ob/obsidian/', 'path_html': '~/my-work/notes/ob/obsidian/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
"}}}
" {{{coc
""""
" snippets
let g:coc_snippet_next = '<tab>'
let g:coc_snippet_prev = '<s-tab>'
" Use <C-j> for both expand and jump (make expand higher priority.)
" imap <C-j> <Plug>(coc-snippets-expand-jump)
let g:coc_global_extensions = [
  \ 'coc-cl',
  \ 'coc-clangd',
  \ 'coc-cmake',
  \ 'coc-css',
  \ 'coc-tsserver',
  \ 'coc-html',
  \ 'coc-java',
  \ 'coc-go',
  \ 'coc-json',
  \ 'coc-kotlin',
  \ 'coc-powershell',
  \ 'coc-perl',
  \ 'coc-yaml',
  \ 'coc-xml',
  \ 'coc-texlab',
  \ 'coc-vimlsp',
  \ 'coc-omnisharp',
  \ 'coc-sh',
  \ 'coc-hls',
  \ 'coc-snippets',
  \ 'coc-phpls',
  \ 'coc-pyright',
	\ ]
                                           \"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Give more space for displaying messages.
set cmdheight=2
function! Show_documentation()
	call CocActionAsync('highlight')
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction
nnoremap <LEADER>H :call Show_documentation()<CR>

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
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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
"}}}
" {{{emmet
"""""""
let g:user_emmet_mode='a'    "enable all function in all mode.
let g:user_emmet_install_global = 0
autocmd FileType xhtml,html,css EmmetInstall
"}}}
" {{{closetag auto
"filenames like *.xml, *.html, *.xhtml,
"These are the file extensions where this plugin is enabled
let g:closetag_filenames = '*.php,*.md,*.html,*.xhtml,*.jsx,*.js,*.tsx'

"filenames like *.xml, *.xhtml, ...
"This will make the list of non-closing tags self-closing in the specified files
let g:closetag_xhtml_filenames = '*.xml,*.xhtml,*.jsx,*.js,*.tsx'

"filetypes like xml html xhtml
"These are the file types where this plugin is enabled
let g:closetag_filetypes = 'html,xhtml,jsx,js,tsx'

"filetypes like xml xhtml
"This will make the list of non-closing tags self-closing in the specified files
let g:closetag_xhtml_filetypes = 'xml,xhtml,jsx,js,tsx'

"integer value [0|1]
"This will make the list of non-closing tags case-sensitive (eg `<Link>` will be closed while `<link>` wont)
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }
"Shortcut for closing tags default is '>'
let g:closetag_shortcut = '>'
"Add > at current position without closing the current tag default is ''
let g:closetag_close_shortcut = '<leader>>'
"}}}
" {{{netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 14
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
nnoremap <C-t> :call ToggleNetrw()<CR>
"}}}
"{{{fzf
nnoremap <A-g> :GFiles<CR>
nnoremap <leader>L :Lines
nnoremap <A-z> :Files<CR>
let g:fzf_preview_window = 'right:60%'
"" Default key bindings
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-h': 'split',
            \ 'ctrl-v': 'vsplit' }
"}}}
"}}}
noremap <LEADER>sc ;setlocal spell!<CR>
inoremap ;g <Esc>/<++><Enter>"_c4l
"{{{languages
"{{{bash
" Check file in shellcheck:
        map <leader>s :!clear && shellcheck -x %<CR>

map <leader>bs ggi#!/bin/sh<Enter>
map <leader>b3 ggi#!/bin/python3<enter>
map <leader>b1 ggi#!/bin/python<enter>
map <leader>bb ggi#!/bin/bash<enter>
map <leader>bz ggi#!/bin/zsh<enter>
"}}}
"{{{html
autocmd FileType html,xhtml,php noremap <A-b> :!$BROWSER %
autocmd FileType html,markdown map <leader>le i<em></em><CR>
autocmd FileType markdown,html map <leader>l1 <h1></h2><Esc>FeT>i
autocmd FileType markdown,html map <leader>l2 <h2></h2><Esc>FeT>i
autocmd FileType markdown,html map <leader>l3 <h3></h3><Esc>FeT>i
autocmd FileType markdown,html map <leader>l4 <h4></h4><Esc>FeT>i
autocmd FileType markdown,html map <leader>l5 <h5></h5><Esc>FeT>i
autocmd FileType markdown,html map <leader>l6 <h6></h6><Esc>FeT>i
autocmd FileType markdown,html map <leader>ldi <div></div><Esc>FeT>i
autocmd FileType html map <leader>lll <li></li><Esc>FeT>i
autocmd FileType html map <leader>lq <q></q><Esc>FeT>i
autocmd FileType html inoremap ;tr <tr></tr><Esc>FeT>i
autocmd FileType html inoremap ;tcg <colgroup></colgroup><Esc>FeT>i
autocmd FileType html inoremap ;tcn <col></col><Esc>FeT>i
autocmd FileType html inoremap ;ta <table><Enter></table>
autocmd FileType html map <leader>lif <iframe></iframe><Space><Space><++><Esc>FeT>i
autocmd FileType html map <leader>lsb <strong></strong><Space><Space><++><Esc>FeT>i
autocmd FileType html map <leader>lsub <sub></sub><Space><Space><++><Esc>FeT>i
autocmd FileType html map <leader>lsup <sup></sup><Space><Space><++><Esc>FeT>i
autocmd FileType html map <leader>lstr <s></s><Space><Space><++><Esc>FeT>i
autocmd FileType html map <leader>lsp <span></span><Esc>FeT>i
autocmd FileType html map <leader>lsm <small></small><Esc>FeT>i
autocmd FileType html map <leader>lscr <script></script><Esc>FeT>i
autocmd FileType html map <leader>lsa <samp></samp><Esc>FeT>i
autocmd FileType html noremap <leader>S i<!DOCTYPE html><enter><html lang="en"><enter><head><enter><meta charset="UTF-8"><enter><title></title><enter><link rel="stylesheet" href=""><enter></head><enter><body><enter><enter></body><enter></html><cr>
" navbar
"autocmd FileType html noremap <leader>lnb i<nav class="navbar"><enter><div class="logo">MUO</div><enter><ul class="nav-links"><enter><input type="checkbox" id="checkbox_toggle" /><enter><label for="checkbox_toggle" class="hamburger">&#9776;</label><enter><div class="menu"><enter><li><a href="/"></a></li><enter><li class="services"><enter><a href="/"></a><enter><ul class="dropdown"><enter><li><a href="/"></a></li><enter></ul><enter></li><enter></div><enter></ul><enter></nav>
" navbar css
"autocmd FileType html,c noremap <leader>lnc i* {<enter>margin: 0;<enter>padding: 0;<enter>box-sizing: border-box;<enter>}<enter>a {<enter>text-decoration: none;<enter>}<enter>li {<enter>list-style: none;<enter>}<enter>.navbar {<enter>display: flex;<enter>align-items: center;<enter>justify-content: space-between;<enter>padding: 20px;<enter>background-color: #676767;<enter>color: #fff;<enter>}<enter>.nav-links a {<enter>color: #fff;<enter>}<enter>.logo {<enter>font-size: 32px;<enter>}<enter>.menu {<enter>display: flex;<enter>gap: 1em;<enter>font-size: 18px;<enter>}<enter>.menu li:hover {<enter>background-color: #4c9e9e;<enter>border-radius: 5px;<enter>transition: 0.3s ease;<enter>}<enter>.menu li {<enter>padding: 5px 14px;<enter>}<enter>.services {<enter>position: relative;<enter>}<enter>.dropdown {<enter>background-color: #676767;<enter>padding: 1em 0;<enter>position: absolute;<enter>display: none;<enter>border-radius: 8px;<enter>top: 35px;<enter>}<enter>.dropdown li + li {<enter>margin-top: 10px;<enter>}<enter>.dropdown li {<enter>padding: 0.5em 1em;<enter>width: 8em;<enter>text-align: center;<enter>}<enter>.dropdown li:hover {<enter>background-color: #4c9e9e;<enter>}<enter>.services:hover .dropdown {<enter>display: block;<enter>}<enter>input[type=checkbox]{<enter>display: none;<enter>}<enter>.hamburger {<enter>display: none;<enter>font-size: 24px;<enter>user-select: none;<enter>}<enter>@media (max-width: 768px) {<enter>.menu {<enter>display:none;<enter>position: absolute;<enter>background-color:#676767;<enter>right: 0;<enter>left: 0;<enter>text-align: center;<enter>padding: 16px 0;<enter>}<enter>.menu li:hover {<enter>display: inline-block;<enter>background-color:#4c9e9e;<enter>transition: 0.3s ease;<enter>}<enter>.menu li + li {<enter>margin-top: 12px;<enter>}<enter>input[type=checkbox]:checked ~ .menu{<enter>display: block;<enter>}<enter>.hamburger {<enter>display: block;<enter>}<enter>.dropdown {<enter>left: 50%;<enter>top: 30px;<enter>transform: translateX(35%);<enter>}<enter>.dropdown li:hover {<enter>background-color: #4c9e9e;<enter>}<enter>}<enter>body {<enter>background-color:black;<Enter>}
"}}}
"{{{markdown
" markdown previewer
au BufWriteCmd,BufRead *.md :w | !cat % > /tmp/vim-mdpre.md
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
"}}}
"{{{vim
autocmd FileType vim map <leader>la iautocmd FileType
autocmd FileType vim map <leader>lm imap <lt>leader>
autocmd FileType vim map <leader>lch iautocmd FileType html map <lt>leader>
autocmd FileType vim map <leader>lch iautocmd FileType python map <lt>leader>
autocmd FileType vim map <leader>lf ifunction <enter><enter>endfunction<esc>kk$i<space>
autocmd FileType vim map <leader>ln inoremap
autocmd FileType vim map <leader>lbf ifunction! <enter><enter>endfunction<esc>kk$i<space>
autocmd FileType vim map <leader>ll i<lt>leader>
"}}}
"{{{auto hotkey
autocmd FileType autohotkey map <leader>la i::ActivateOrOpen("<++>","<++>")
"}}}
"{{{c
autocmd FileType c map <leader>lp iprintf();<Esc>hhi
autocmd FileType c map <leader>lar iint main (int argc, char *argv[])<Enter>{<Enter>  char *argument;<Enter>}
"}}}
"{{{c++
autocmd FileType cpp map <leader>lco icout <<
autocmd FileType cpp map <leader>lci icin >>
"}}}
"{{{python
autocmd FileType python map <leader>lin iinput("")<Esc>hhi
let g:python_highlight_all = 1
autocmd BufNewFile,BufRead requirements*.txt set ft=python
autocmd FileType python map <leader>lii iint(input(""))<Esc>hhi
"}}}
"{{{auto it
autocmd FileType autoit map <leader>lex iRun("")<Esc>hi
"}}}
"{{{haskell
autocmd FileType haskell map <leader>lsp i, ("", spawn "")
"}}}
"{{{powershell
autocmd FileType ps1 map <leader>lki iGet-Process  \| Stop-Process<Esc>14hi
autocmd FileType ps1 map <leader>lpo ipowercfg.exe -SETACTIVE
autocmd FileType ps1 map <leader>lvo i$obj = new-object -com wscript.shell<Enter>$obj.SendKeys([char]173)
autocmd FileType ps1 map <leader>lgne iNew-Object system.Windows.Forms.Button
autocmd FileType ps1 map <leader>lsip iSet-ItemProperty -Path
autocmd FileType ps1 map <leader>lds iDisable-ScheduledTask -TaskName
autocmd FileType ps1 map <leader>lsp iStop-Process -Name
autocmd FileType ps1 map <leader>lri iRemove-ItemProperty -Path
"}}}
"{{{javascript
autocmd FileType javascript map <leader>lcn iclassName=""<esc>i
autocmd FileType javascript map <leader>lir iisRequired,
autocmd FileType javascript map <leader>lset ithis.setState({<Enter><enter>});<esc>ki
"}}}
"}}}
autocmd BufRead,BufNewFile /tmp/neomutt* :call ToggleHiddenAll()
" Replace all is aliased to S.
      nnoremap S :%s//g<Left><Left>
" Fix indenting visual block
noremap <A-x> :r!date "+\%F"<CR>
noremap DD1 "add
noremap DD2 "sdd
noremap DD3 "rdd
noremap DD4 "fdd
noremap DD5 "gdd
noremap DD6 "hdd
noremap DD7 "zdd
noremap DD8 "xdd
noremap DD9 "cdd
noremap P1 "ap
noremap P2 "sp
noremap P3 "rp
noremap P4 "fp
noremap P5 "gp
noremap P6 "hp
noremap P7 "zp
noremap P8 "xp
noremap P9 "cp
noremap Y1 "ay
noremap Y2 "sy
noremap Y3 "ry
noremap Y4 "fy
noremap Y5 "gy
noremap Y6 "hy
noremap Y7 "zy
noremap Y8 "xy
noremap Y9 "cy
noremap <leader>o iAut dolorem dignissimos assumenda voluptatem tenetur recusandae. Ut et qui rerum eos optio rerum.<Enter>Aperiam architecto eos aut molestias. Non asperiores aliquam quo qui labore cum.<Enter>Mollitia beatae iste expedita explicabo aut. Perspiciatis facere aliquam iste sint. Sapiente aut itaque dolorum ut quis aut.<Enter>Iste adipisci in occaecati. Molestiae eligendi et ea nisi.<enter>Eum quibusdam nulla officiis. Corporis nostrum sint deserunt doloremque. Iusto asperiores omnis ducimus voluptatem consequuntur qui minus.<enter>Occaecati libero dicta ex voluptatem harum. Cumque aspernatur ut sapiente.<CR>

autocmd FileType css map <leader>lln ilist-style: none;
autocmd FileType java map <leader>ls iSystem.out.println();<esc>hi
" Call figlet
noremap tx :r !figlet
noremap <A-t> :r !date "+\%R:\%S"
" autocmd FileType html map <leader>lme i<meta name="robots" content="noindex,nofollow">
autocmd FileType autohotkey setlocal commentstring=;\ %s
autocmd FileType autoit setlocal commentstring=;\ %s
autocmd FileType vifm setlocal commentstring=\"\ %s
nnoremap ; :
nnoremap : ;
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/
noremap <leader>y "+y
noremap <leader>p "+p
" Make sure .aliases, .bash_aliases and similar files get syntax highlighting.
autocmd BufNewFile,BufRead .*aliases* set ft=sh

" Make sure Kubernetes yaml files end up being set as helm files.
au BufNewFile,BufRead *.{yaml,yml} if getline(1) =~ '^apiVersion:' || getline(2) =~ '^apiVersion:' | setlocal filetype=helm | endif
" Ensure tabs don't get converted to spaces in Makefiles.
autocmd FileType make setlocal noexpandtab
nnoremap <leader>] :TagbarToggle<CR>
command -nargs=* Nohtml :%s#<\_.\{-1,}>##g " delete html tags, leave text
command -nargs=* Noblankline :g/^\s*$/d " delete all blank lines
au BufWriteCmd,BufRead *.ms :w | !groff -m ms % -T ps > /tmp/groff.ps
autocmd FileType groff map <leader>l2 i.NH 2<CR>
autocmd FileType groff map <leader>l3 i.NH 3<CR>
autocmd FileType groff map <leader>l4 i.NH 4<CR>
autocmd FileType groff map <leader>l5 i.NH 5<CR>
autocmd FileType groff map <leader>l6 i.NH 6<CR>
autocmd FileType groff map <leader>l7 i.NH 7<CR>
let g:vim_jsx_pretty_colorful_config = 1
" Make space more useful
nnoremap <space> za
autocmd BufNewFile,BufRead *.rss,*.atom         setfiletype xml
autocmd FileType css setlocal ts=2 sts=2 sw=2 noexpandtab
autocmd FileType html setlocal ts=2 sts=2 sw=2 noexpandtab
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>
" Use a block cursor in normal mode, i-beam cursor in insertmode
if empty($TMUX)
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
else
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
endif
" Enable 256 colors in vim
set t_Co=256
nnoremap <silent> <Leader>`        :Marks<CR>
" stop vim from silently messing with files that it shouldn't
set nofixendofline
hi StatusLine ctermfg=black ctermbg=NONE
hi StatusLineNC ctermfg=black ctermbg=NONE
" better use of arrow keys, number increment/decrement
nnoremap <up> <C-a>
nnoremap <down> <C-x>
nmap :: A;<esc>
" Minimum lines to keep above and below cursor when scrolling
set scrolloff=3
" Ask for confirmation when handling unsaved or read-only files
set confirm
" Show hostname, full path of file and last-mod time on the window title. The
" meaning of the format str for strftime can be found in
" http://man7.org/linux/man-pages/man3/strftime.3.html. The function to get
" lastmod time is drawn from https://stackoverflow.com/q/8426736/6064933
set title
set titlestring=
set titlestring+=%(%{hostname()}\ \ %)
set titlestring+=%(%{expand('%:p')}\ \ %)
set titlestring+=%{strftime('%Y-%m-%d\ %H:%M',getftime(expand('%')))}
" Do not load tohtml.vim
let g:loaded_2html_plugin = 1
xnoremap ; :
" Turn the word under cursor to upper case
inoremap <c-u> <Esc>viwUea
" hi TabLineFill ctermfg=LightGreen ctermbg=DarkGreen
" hi TabLine ctermfg=Blue ctermbg=Yellow
" hi TabLineSel ctermfg=Red ctermbg=Yellow
" hi Title ctermfg=LightBlue ctermbg=Magenta
set tabline=%!MyTabLine()  " custom tab pages line
function! MyTabLine()
  let s = ''
  " loop through each tab page
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#' " WildMenu
    else
      let s .= '%#Title#'
    endif
    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T '
    " set page number string
    let s .= i + 1 . ''
    " get buffer names and statuses
    let n = ''  " temp str for buf names
    let m = 0   " &modified counter
    let buflist = tabpagebuflist(i + 1)
    " loop through each buffer in a tab
    for b in buflist
      if getbufvar(b, "&buftype") == 'help'
        " let n .= '[H]' . fnamemodify(bufname(b), ':t:s/.txt$//')
      elseif getbufvar(b, "&buftype") == 'quickfix'
        " let n .= '[Q]'
      elseif getbufvar(b, "&modifiable")
        let n .= fnamemodify(bufname(b), ':t') . ', ' " pathshorten(bufname(b))
      endif
      if getbufvar(b, "&modified")
        let m += 1
      endif
    endfor
    " let n .= fnamemodify(bufname(buflist[tabpagewinnr(i + 1) - 1]), ':t')
    let n = substitute(n, ', $', '', '')
    " add modified label
    if m > 0
      let s .= '+'
      " let s .= '[' . m . '+]'
    endif
    if i + 1 == tabpagenr()
      let s .= ' %#TabLineSel#'
    else
      let s .= ' %#TabLine#'
    endif
    " add buffer names
    if n == ''
      let s.= '[No Name]'
    else
      let s .= n
    endif
    " switch to no underlining and add final space
    let s .= ' '
  endfor
  let s .= '%#TabLineFill#%T'
  " right-aligned close button
  " if tabpagenr('$') > 1
  "   let s .= '%=%#TabLineFill#%999Xclose'
  " endif
  return s
endfunction
hi TabLineFill cterm=reverse ctermfg=0 gui=reverse
"Quickly re-select either the last pasted or changed text
noremap gV `[v`]
" Format a paragraph or visual selection to 80 character lines
nnoremap <Leader>g gqap
xnoremap <Leader>g gqa
nnoremap Y y$
nnoremap <leader><leader> <c-^>
"" Visual yank to/from system register
vmap <C-Y> "+y
nmap <C-P> "+p
nnoremap <Leader>c :let @/=''<CR>:echo<CR>,c
nnoremap q; q:
