"  Tecix's VIMRC (NeoVim)
"  SET OUT STUFF
" -----------------------
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype off

" Plug-Ins Installation via vim-plug
" -------------------------------
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" Plug 'vimwiki/vimwiki'
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
" Plug 'plasticboy/vim-markdown' 
" Plug 'PsiPhire/neuron.vim'
" Plug 'dkarter/bullets.vim'
" Plug 'shushcat/vim-minimd'
" Plug 'ThePrimeagen/vim-be-good', {'do': './install.sh'}
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'machakann/vim-highlightedyank' 
Plug 'morhetz/gruvbox'
Plug 'rlue/vim-barbaric'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'BurntSushi/ripgrep'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'
Plug 'dbeniamine/cheat.sh-vim'
" Plug 'ZachariasLenz/neuron.vim'
Plug 'SidOfc/mkdx'
Plug 'tpope/vim-surround'
Plug 'liuchengxu/vim-which-key'
Plug 'subnut/nvim-ghost.nvim', {'do': ':call nvim_ghost#installer#install()'}


call plug#end()

filetype plugin indent on

" THEME
colorscheme gruvbox

syntax on

set modeline
set nowrap
set hidden
set number relativenumber
set incsearch
set hlsearch
set ignorecase
set smartcase
set wildmenu
set autoindent
set clipboard+=unnamedplus
set shell=/usr/bin/zsh
set pastetoggle=<F2>
set scrolloff=3

set encoding=UTF-8
set mouse=a 
set tabstop=4 
set softtabstop=0
set shiftwidth=4

set undodir=~/.vim/undodir
set undofile
" set foldmethod=syntax 

let mapleader = " "
" ------------------------------ 
" KEY BIDDINGS / KEY MAPPINGS
" ------------------------------ 
map Y y$"
inoremap <C-U> <C-G>u<C-U>
nnoremap <Leader>g :Goyo<CR>
noremap <Leader>w :set wrap!<CR>
noremap <C-l> :noh<CR><C-L>
noremap <C-h> :History<CR>
noremap <C-p> :Files<CR>
noremap <C-M-p> :Rg<CR>

"
" Configure for Python development
let g:pymode_run_bind='<F5>'
" noremap <F5> <Esc>:w<CR>:!python3 %<CR>
autocmd FileType python map <buffer> <F5> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F5> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>


" For Emacs-style editing on the command-line: >
" --------------------------------------------
" start of line
cnoremap <C-A>		<Home>
" back one character
cnoremap <C-B>		<Left>
" delete character under cursor
cnoremap <C-D>		<Del>
" end of line
cnoremap <C-E>		<End>
" forward one character
cnoremap <C-F>		<Right>
" recall newer command-line
cnoremap <C-N>		<Down>
" recall previous (older) command-line
cnoremap <C-P>		<Up>
" back one word
cnoremap <Esc><C-B>	<S-Left>
cnoremap <M-b> <S-Left>
" forward one word
cnoremap <Esc><C-F>	<S-Right>
cnoremap <M-f> <S-Right>

" Readline in insertmode
inoremap <c-a> <c-o>0
inoremap <c-e> <c-o>$



" AUTOCOMMANDS
" ---------------------
" NOTE: Don't know why this not work with my NeoVim
" augroup highlight_yank
"     autocmd!
"     autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)
" augroup END

augroup TerminalStuff
	autocmd!
	autocmd TermEnter * setlocal nonumber norelativenumber
	autocmd TermLeave * setlocal number relativenumber
augroup END

". PLUG-INS CONFIGURATION
" ------------------------- 

" vim-which-key
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

let g:highlightedyank_highlight_duration = 250

let g:netrw_preview = 1
" let g:vimwiki_list = [{ 'path': '~/notes/', 'syntax':'markdown', 'ext': '.md' }]
let g:vim_markdown_folding_disabled = 1
set conceallevel=2

let g:mkdx#settings     = { 'highlight': { 'enable': 1 },
                        \ 'enter': { 'shift': 1 },
                        \ 'links': { 'external': { 'enable': 1 } },
                        \ 'toc': { 'text': 'Table of Contents', 'update_on_write': 1 },
                        \ 'fold': { 'enable': 0 },
						\ 'tokens': { 'list': '*' },
						\ 'gf_on_steroids': 1 }

nmap <Plug> <Plug>(mkdx-text-italic-n)
vmap <Plug> <Plug>(mkdx-text-italic-v)
nmap <Plug> <Plug>(mkdx-indent)

" --------
" Working with my notes
" ----------
" let notesdir= "~/notes"
" autocmd FileType markdown setl suffixesadd+=.md
" noremap <Leader>no :lcd `=notesdir`<CR>:Rg<CR>
let g:neuron_search_backend = 'rg'
" let g:neuron_inline_backlinks = 0

" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path

" auto-sync notes
" augroup auto_sync_notes
" 	function PullNotes()
" 		" system('cd ~/notes;git fetch')
" 		" let gstatus = system('git status --porcelain')
" 		" if gstatus != 0
" 		"  	!cd ~/notes;git pull origin master
" 		" endif
" 		let choice = confirm("Pull notes?", "&Yes\n&No",2)
" 	    if choice == 1	
" 		 	!cd ~/notes;git pull origin master
" 		endif
" 	endfunction

" 	function PushNotes()
" 		let choice = confirm("Push updated notes?", "&Yes\n&No",2)
" 	    if choice == 1	
" 			!cd ~/notes;git add .;git commit -m "Auto commit of %:t." "%";git push origin master
" 		endif
" 	endfunction

" 	autocmd!
" 	" autocmd VimEnter ~/notes/* call PullNotes() 
" 	" autocmd BufWritePost ~/notes/* call PushNotes()
" augroup END

if executable(s:clip)
    augroup WSLYank
            autocmd!
            autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif

" ----------------------------------------------------------------------------
"  goyo.vim + limelight.vim
" ----------------------------------------------------------------------------
 " Color name (:help cterm-colors) or ANSI code
 let g:limelight_conceal_ctermfg = 'gray'
 let g:limelight_conceal_ctermfg = 240

 " Color name (:help gui-colors) or RGB color
 let g:limelight_conceal_guifg = 'DarkGray'
 let g:limelight_conceal_guifg = '#777777'

 " Default: 0.5
 let g:limelight_default_coefficient = 0.7

 " Number of preceding/following paragraphs to include (default: 0)
 let g:limelight_paragraph_span = 1

 " Beginning/end of paragraph
 "   When there's no empty line between the paragraphs
 "   and each paragraph starts with indentation
 let g:limelight_bop = '^\s'
 let g:limelight_eop = '\ze\n^\s'

 " Highlighting priority (default: 10)
 "   Set it to -1 not to overrule hlsearch
 let g:limelight_priority = -1

 function! s:goyo_enter()
 	set noshowmode
 	set noshowcmd
 	set scrolloff=999
 	Limelight
 	" set background=light
 	set linespace=7
 	set wrap
 	" Limelight
 	let &l:statusline = '%M'
 	hi StatusLine ctermfg=red guifg=red cterm=NONE
 endfunction

 function! s:goyo_leave()
 	set showmode
 	set showcmd
 	set scrolloff=5
 	Limelight!	
  	" set background=dark
 	set linespace=0
 	set nowrap
 	" Limelight!
 endfunction

 autocmd! User GoyoEnter nested call <SID>goyo_enter()
 autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Configure for Python
" ---------------------
autocmd BufRead *.py
    \ set expandtab       |" replace tabs with spaces
    \ set autoindent      |" copy indent when starting a new line
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4

" Configure FZF
" --------------------
" FZF notes
" command! -bang -nargs=* Find
"   \ call fzf#vim#grep('rg --column --line-number --no-heading --color=always '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
"
command! -bang -nargs=* Find call fzf#vim#grep('rg --vimgrep --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" '.shellescape(<q-args>), 1, <bang>0)
"
