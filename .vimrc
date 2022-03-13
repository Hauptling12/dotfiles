"""""""""""""""""""""""
" some basics
"""""""""""""""""""""""
set noswapfile
set number relativenumber       " Display line numbers
syntax on
set encoding=utf-8
set hlsearch
set incsearch
" makes clipboard save to system
set clipboard+=unamedplus
vnoremap <C-c> "+y
set autoindent
set hidden               
set splitbelow splitright
" highlight operaters
set showmatch
""""""""""""""""""
"" plugins
""""""""""""""""""
set nocompatible              " be iMproved, required
filetype plugin on                  " required


call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the a\
Plug 'itchyny/lightline.vim'
"Plugin 'preservim/nerdtree'                        " Nerdtree
"Plugin 'ryanoasis/vim-devicons'
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'     " Highlighting Nerdtree
Plug 'ryanoasis/vim-devicons'                      " Icons for Nerdtree
Plug 'bfrg/vim-cpp-modern'
Plug 'neoclide/coc-sources'
Plug 'preservim/nerdcommenter'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'majutsushi/tagbar'
Plug 'vifm/vifm.vim'
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}
Plug 'vifm/vifm.vim'
Plug 'alvan/vim-closetag'
Plug 'iamcco/markdown-preview.nvim' 
Plug 'vimwiki/vimwiki'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'PotatoesMaster/i3-vim-syntax'                " i3 config highlighting
    Plug 'kovetskiy/sxhkd-vim'                         " sxhkd highlighting
    Plug 'vim-python/python-syntax'                    " Python highlighting
Plug 'mbbill/undotree'
Plug 'mattn/emmet-vim'
"Plugin 'ap/vim-css-color'
call plug#end()
" tab indents 3 spaces
set expandtab
" Enable autocompletion:
	set wildmode=longest,list,full
" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
        " Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_us<CR>


"""
let g:NERDCreateDefaultMappinfa = 1
"""
"""
" instant markdown previewer
"""
let g:instant_markdown_autostart = 0
let g:instant_markdown_mermaid = 1
let g:instant_markdown_slow = 0
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
nmap <leader>cl  <Plug>(coc-codelens-action)

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
""""""""""""""""
" vimwiki
""""""""""""""
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

""""""""""""""""""""""""""
" emmet
"""::::::::::::::::::::
let g:user_emmet_mode='a'    "enable all function in all mode.
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

"""""""
" markdown previewer
"""""""
" set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0

" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0

" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''

" specify browser to open preview page
" default: ''
let g:mkdp_browser = ''

" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
" content_editable: if enable content editable for preview page, default: v:false
" disable_filename: if disable filename header for preview page, default: 0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0
    \ }

" use a custom markdown style must be absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
let g:mkdp_markdown_css = ''

" use a custom highlight style must absolute path
" like '/Users/username/highlight.css' or expand('~/highlight.css')
let g:mkdp_highlight_css = ''

" use a custom port to start server or random for empty
let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'

" recognized filetypes
" these filetypes will have MarkdownPreview... commands
let g:mkdp_filetypes = ['markdown']

"""
" closetag auto
"""
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
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
"""""""""""""""""
" keybindings remaped
"""""""""""""""""
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
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
""autocmd FileType html inoremap <Space><Space> <Esc>/<++><Enter>"_c4l
""" html
autocmd FileType html inoremap ;e <em></em><Esc>FeT>i
autocmd FileType html inoremap ;1 <h1></h2><Esc>FeT>i
autocmd FileType html inoremap ;2 <h2></h2><Esc>FeT>i
autocmd FileType html inoremap ;3 <h3></h3><Esc>FeT>i
autocmd FileType html inoremap ;4 <h4></h4><Esc>FeT>i
autocmd FileType html inoremap ;5 <h5></h5><Esc>FeT>i
autocmd FileType html inoremap ;6 <h6></h6><Esc>FeT>i
autocmd FileType html inoremap ;d <div></div><Esc>FeT>i
autocmd FileType html inoremap ;l <li></li><Esc>FeT>i
autocmd FileType html inoremap ;p <p></p><Esc>FeT>i
autocmd FileType html inoremap ;o <ol><Enter></ol>
autocmd FileType html inoremap ;b <b></b><Esc>FeT>i
autocmd FileType html inoremap ;u <ul><Enter></ul>
autocmd FileType html inoremap ;co <code></code><Esc>FeT>i
autocmd FileType html inoremap ;q <q></q><Esc>FeT>i
autocmd FileType html inoremap ;h <a href=""></a><Esc>FeT>i
autocmd FileType html inoremap ;a <article><Enter></article><Esc>FeT>i
autocmd FileType html inoremap ;tr <tr></tr><Esc>FeT>i
autocmd FileType html inoremap ;tcg <colgroup></colgroup><Esc>FeT>i
autocmd FileType html inoremap ;tcn <col></col><Esc>FeT>i
autocmd FileType html inoremap ;ta <table><Enter></table>
autocmd FileType html inoremap ;wr <!DOCTYPE><Enter><html><Enter><head><Enter><Enter></head><Enter><body><Enter><Enter></body><Enter></html>
autocmd FileType html inoremap ;ct <!-- --><Space><Space><++><Esc>FeT>i
autocmd FileType html inoremap ;if <iframe></iframe><Space><Space><++><Esc>FeT>i
autocmd FileType html inoremap ;im <img src="" alt=""><Enter><++><Esc>FeT>i
autocmd FileType html inoremap ;in <i></i><Space><Space><++><Esc>FeT>i
autocmd FileType html inoremap ;sb <strong></strong><Space><Space><++><Esc>FeT>i
autocmd FileType html inoremap ;sub <sub></sub><Space><Space><++><Esc>FeT>i
autocmd FileType html inoremap ;sup <sup></sup><Space><Space><++><Esc>FeT>i
autocmd FileType html inoremap ;str <s></s><Space><Space><++><Esc>FeT>i
autocmd FileType html inoremap ;sp <span></span><Esc>FeT>i
autocmd FileType html inoremap ;sm <small></small><Esc>FeT>i
autocmd FileType html inoremap ;scr <script></script><Esc>FeT>i
autocmd FileType html inoremap ;sol <source lang=""></source><Esc>>i
autocmd FileType html inoremap ;sa <samp></samp><Esc>FeT>i
autocmd FileType html inoremap á &aacute;
autocmd FileType html inoremap é &eacute;
autocmd FileType html inoremap í &iacute;
autocmd FileType html inoremap ó &oacute;
autocmd FileType html inoremap ú &uacute;
autocmd FileType html inoremap ä &auml;
autocmd FileType html inoremap ë &euml;
autocmd FileType html inoremap ï &iuml;
autocmd FileType html inoremap ö &ouml;
autocmd FileType html inoremap ü &uuml;
autocmd FileType html inoremap ã &atilde;
autocmd FileType html inoremap ẽ &etilde;
autocmd FileType html inoremap ĩ &itilde;
autocmd FileType html inoremap õ &otilde;
autocmd FileType html inoremap ũ &utilde;
autocmd FileType html inoremap ñ &ntilde;
autocmd FileType html inoremap à &agrave;
autocmd FileType html inoremap è &egrave;
autocmd FileType html inoremap ì &igrave;
autocmd FileType html inoremap ò &ograve;
autocmd FileType html inoremap ù &ugrave;
autocmd FileType html inoremap á &aacute;
autocmd FileType html inoremap é &eacute;
autocmd FileType html inoremap í &iacute;
autocmd FileType html inoremap ó &oacute;
autocmd FileType html inoremap ú &uacute;
autocmd FileType html inoremap ;'ä
autocmd FileType html inoremap ;'ë 
autocmd FileType html inoremap ;'ï 
autocmd FileType html inoremap ;'ö
autocmd FileType html inoremap ;.u ü 
autocmd FileType html inoremap ;.a ã 
autocmd FileType html inoremap ;.e ẽ 
autocmd FileType html inoremap ;.i ĩ 
autocmd FileType html inoremap ;.o õ 
autocmd FileType html inoremap ;.u ũ 
autocmd FileType html inoremap ;,n ñ 
autocmd FileType html inoremap ;,a à 
autocmd FileType html inoremap ;,e è 
autocmd FileType html inoremap ;,i ì 
autocmd FileType html inoremap ;,o ò
autocmd FileType html inoremap ;,u ù 
""" markdown
autocmd FileType md inoremap ;e <em></em><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;1 <h1></h2><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;2 <h2></h2><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;3 <h3></h3><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;4 <h4></h4><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;5 <h5></h5><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;6 <h6></h6><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;d <div></div><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;l <li></li><Space><Space><Enter><++><Esc>FeT>i
autocmd FileType md inoremap ;p <p></p><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;o <ol></ol><Enter><Enter><++>
autocmd FileType md inoremap ;b <b></b><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;u <ul></ul><Enter><Enter><++>
autocmd FileType md inoremap ;co <code></code><Space><Space><Esc>FeT>i
autocmd FileType md inoremap ;q <q></q><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;h <a href=""></a><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;a <article><Enter></article><Enter><++>FeT>i
autocmd FileType md inoremap ;tr <tr></tr><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;im <img src="" alt=""><Enter><++><Esc>FeT>i
autocmd FileType md inoremap ;in <i></i><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;sb <strong></strong><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;sub <sub></sub><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;sup <sup></sup><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;str <s></s><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;sp <span></span><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;sm <small></small><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;scr <script></script><Space><Space><++><Esc>FeT>i
autocmd FileType md inoremap ;sol <source lang=""></source><Enter><Esc>>i
autocmd FileType md inoremap ;sa <samp></samp><Space><Space><++><Esc>FeT>i
"""" uny
autocmd FileType md inoremap ;wilf <Enter>//22<Enter>Wilf:<Enter><Enter>Walt:<Enter>

""" bash

""""""
"" autoclose
""""""
"auto close {
"function! s:CloseBracket()
"    let line = getline('.')
"    if line =~# '^\s*\(struct\|class\|enum\) '
"        return "{\<Enter>};\<Esc>O"
"    elseif searchpair('(', '', ')', 'bmn', '', line('.'))
"        " Probably inside a function call. Close it off.
"        return "{\<Enter>});\<Esc>O"
"    else
"        return "{\<Enter>}\<Esc>O"
"    endif
"endfunction
"inoremap <expr> {<Enter> <SID>CloseBracket()
""inoremap " ""<left>
""inoremap ' ''<left>
""inoremap { {}<left>
""inoremap ( ()<left>
""inoremap [ []<left>

"""""""""""""""""""""""""""""""""
" => Status Line
"""""""""""""""""""""""""""""""""
" The lightline.vim theme
let g:lightline = {
      \ 'colorscheme': 'darcula',
      \ }

" Always show statusline
set laststatus=2

" Uncomment to prevent non-normal modes showing in powerline and below powerline.
set noshowmode

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Uncomment to autostart the NERDTree
""autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '►'
let g:NERDTreeDirArrowCollapsible = '▼'
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeMinimalUI = 1
let g:NERDTreeWinSize=38
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
""""""""""""""""""""""""""""""
" => Other Stuff
""""""""""""""""""""""""""""""
let g:python_highlight_all = 1

set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
