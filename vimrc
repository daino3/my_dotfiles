" Use Vim settings, rather then Vi settings. This setting must be as early as
" possible, as it has side effects.
set nocompatible

" Leader
let mapleader = " "

set shell=/bin/sh                       " Ensure vim always loads correct RVM

set autoread                            " reload files automatically
set autowrite                           " Automatically :write before running commands
set backspace=2                         " Backspace deletes like most programs in insert mode
set clipboard=unnamed                   " yank and paste from vim
set colorcolumn=+1
set cursorline                          " highlight current line
set diffopt+=vertical                   " Always use vertical diffs
set expandtab
set history=50
set hlsearch                            " higlight all words under cursor in file with '*'; prev use '#'
set incsearch                           " do incremental searching
set laststatus=2                        " Always display the status line
set list listchars=tab:»·,trail:·,nbsp:·" Display extra whitespace
set nobackup
set noswapfile                          " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set nowritebackup
set numberwidth=5                       " Numbers
set relativenumber                      " Numbers
set ruler                               " show the cursor position all the time
set shiftround
set shiftwidth=2
set showcmd                             " display incomplete commands
set splitbelow                          " Open new split panes to right and bottom, which feels more natural
set splitright                          " Open new split panes to right and bottom, which feels more natural
set tabstop=2                           " Softtabs, 2 spaces
set textwidth=100                       " Make it obvious where 80 characters is
set wrap
set mouse=a                             " enable mouse (want this for nerdtree)
set mousemodel=popup_setpos
set ttymouse=xterm2
set paste                               " dont fuck up formatting when pasting from other applications

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" autload NERDTree when you enter Vim
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
" Shortcut for NERDTreeToggle
nmap <leader>nt :NERDTreeToggle<CR>:wincmd p<CR>
nmap <leader>n :NERDTree %<CR>:wincmd p<CR>
let g:NERDTreeWinPos = "left"
let g:NERDTreeMouseMode = 3
let g:NERDTreeShowHidden = 1

" copy when selecing text with mouse
:vmap <C-C> "+y

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand('~/.vimrc.bundles'))
  source ~/.vimrc.bundles
endif

filetype plugin indent on

" Remove trailing whitespace after save
autocmd BufWritePre * :%s/\s\+$//e

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Cucumber navigation commands
  autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
  autocmd User Rails Rnavcommand config config -glob=**/* -suffix=.rb -default=routes

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END
" set js syntax highlighting for json files
autocmd BufNewFile,BufRead *.json set ft=javascript

" sort css files
:command! Sortcss :g#\({\n\)\@<=#.,/}/sort

" format json
:command! FormatJSON :%!python -m json.tool

" let g:rspec_command = 'call Send_to_Tmux("zeus test {spec}\n")'
" let g:rspec_command = "!rspec {spec}"
" let g:rspec_command = 'call Send_to_Tmux("bundle exec foreman run -e test.env rspec {spec}\n")'
" let g:rspec_command = GetTestCommand()
nmap <Leader>t :w\|:!echo "rspec --color %" > test-commands<cr>

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" bind \ (backward slash) to grep shortcut
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>
" bind F to grep word under cursor
nnoremap F :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" buffers / tabs
nmap <Leader>l :bnext <Enter>
nmap <Leader>h :bprevious <Enter>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>

" open c-window
nnoremap <Leader>C :copen <Enter>

" bind E to Explorer mode
nnoremap <Leader>E :Explore<CR>

" Save current file
nnoremap <Leader>w :update<CR>

" Color scheme
colorscheme distinguished
highlight NonText guibg=#060606
highlight Folded  guibg=#0A0A0A guifg=#9090D0

function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>
map <D-S-]> gt
map <D-S-[> gT

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" pwd of current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
" view / edit selected file
map <leader>e :edit %%
map <leader>v :view %%

" vim-rspec mappings
" nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
" nnoremap <Leader>s :call RunNearestSpec()<CR>
" nnoremap <Leader>l :call RunLastSpec()<CR>

" Run commands that require an interactive shell
" nnoremap <Leader>r :RunInInteractiveShell<space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Quicker window navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

nnoremap <S-j> 10j
nnoremap <S-k> 10k

" :help window-moving
" Quicker window placement / Get off my lawn
nnoremap <Leader><Left> <C-w>H
nnoremap <Leader><Right> <C-w>L
nnoremap <Leader><Up> <C-w>K
nnoremap <Leader><Down> <C-w>J

" Better copy pasting
nnoremap <Leader>p viw"0p

" :help window-size
" Quicker window resizing
if bufwinnr(1)
 map + 15<C-w>> " bigger
 map _ 15<C-w>< " smaller
 map } :res +10 <Enter> " shorter
 map { :res -10 <Enter> " taller
endif

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Insert lines w/o going into insert mode
nnoremap <Leader><Enter> <S-o><Esc>

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
