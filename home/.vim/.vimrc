".vimrcの最初に書くおまじない
filetype off

"dein.vimの設定
if &compatible
    set nocompatible
endif

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . s:dein_repo_dir
endif

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    let s:toml = '~/.dein.toml'
    let s:lazy_toml = '~/.dein_lazy.toml'
    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})

    let g:dein#install_process_timeout =  600
    if has('job') && has('channel') && has('timers')
      call dein#add('w0rp/ale')
    else
      call dein#add('vim-syntastic/syntastic')
    endif
    let g:dein#install_process_timeout =  120

    if ((has('nvim')  || has('timers')) && has('python3')) && system('pip3 show neovim') !=# ''
        call dein#add('Shougo/deoplete.nvim')
        if !has('nvim')
            call dein#add('roxma/nvim-yarp')
            call dein#add('roxma/vim-hug-neovim-rpc')
        endif
    elseif has('lua')
        call dein#add('Shougo/neocomplete.vim')
    endif

    call dein#end()
    call dein#save_state()
endif

if dein#tap('deoplete.nvim')
  let g:deoplete#enable_at_startup = 1
elseif dein#tap('neocomplete.vim')
  let g:neocomplete#enable_at_startup = 1
endif

if dein#check_install()
    call dein#install()
endif

if !has('nvim')
  packadd! matchit
  runtime ftplugin/man.vim
endif

augroup vimrc
  autocmd!
augroup END

" colors
if has('gui_running')
  let s:color_level = 2
elseif $TERM !~? '.*-256color'
  let s:color_level = 0
elseif !has('termguicolors')
  let s:color_level = 1
else
  let s:color_level = 2
  if !has('nvim') && $TERM =~? 'screen'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
endif



"色
"colorschemeの微調整
"colorschemeより前に書く
autocmd ColorScheme * highlight Comment ctermfg=245

if s:color_level >=? 2
  set termguicolors
endif
if s:color_level >=? 1
  set background=dark
  try
    let g:molokai_original = 1
    let g:rehash256 = 1
    colorscheme molokai
    set t_Co=256
  catch /E185:/ " colorscheme doesn't exist
  endtry
endif



"indentline unset expandtab
"tab、indentの可視化
set list lcs=tab:\|\
let g:indentLine_color_term = 239
let g:indentLine_char = '.'
set listchars=tab:>-,trail:.,extends:>,precedes:<,nbsp:%

set colorcolumn=81
set ruler
set showcmd
set cmdheight=1
set laststatus=2
set lazyredraw
set wildmenu
set wildignorecase
set title

"encoding settings
set ff=unix
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932

"tabの入力
set expandtab

"自動でインデントを行う時の幅
set shiftwidth=4

"tabの幅
set softtabstop=4

"tabを含むファイルを開いた時のtabの幅
set tabstop=2

"対応する括弧の非表示
set noshowmatch
let loaded_matchparen = 1

"文字幅が不明な場合2バイトに固定
set ambiwidth=double

"ステータス行の内容
set statusline=%<%f%=%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%9(\ %m%r\ %)[%4v][%12(\ %5l/%5L%)]

"vimでbackspaceを入れても無反応 or Delete状態の時のおまじない
noremap  
noremap!  

"backsapceで削除できるものの指定
"おまじないその2
set backspace=indent,eol,start

"returnキーで改行
noremap <CR> o<ESC>

"autoindent
set smartindent

"行数表示
set number

"起動時のメッセージを消す
set shortmess+=I

"外部で変更のあったファイルは読み直す
set autoread

"現在の行/列の強調
set cursorline
set cursorcolumn

"行末の1文字先までカーソルを移動できるようにする
set virtualedit=onemore

"Escでハイライト消去
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"windowサイズ調整
let g:winresizer_start_key = '<C-E>'

"neotermの基本設定
set sh=bash

"shellをEscで抜ける
if exists(':tnoremap')
    tnoremap <silent> <ESC> <C-\><C-n>
endif

"マウスで選択してもVisualモードにしない
set mouse-=a

if exists('+inccommand')
  set inccommand=split
endif

" show whitespace errors
hi link WhitespaceError Error
au vimrc Syntax * syn match WhitespaceError /\s\+$\| \+\ze\t/

""""""""""""
"  Search  "
""""""""""""
"インクリメンタル検索の有効化
set incsearch
"検索結果をハイライト
set hlsearch
"検索時に大文字と小文字を区別しない
set ignorecase
set smartcase
"検索がファイル末尾まで進んだらファイル先頭から再び検索する
set wrapscan
set tags=./tags;,tags

"""""""""""
"  Cache  "
"""""""""""
if !has('nvim')
  set viminfo+=n~/.cache/vim/viminfo
endif
set dir=~/.cache/vim/swap//
set backup
set backupdir=~/.cache/vim/backup
set undofile
set undodir=~/.cache/vim/undo
for s:d in [&dir, &backupdir, &undodir]
  if !isdirectory(s:d)
    call mkdir(iconv(s:d, &encoding, &termencoding), 'p')
  endif
endfor

""""""""""
"  Misc  "
""""""""""
let g:tex_flavor='latex'

" EasyMotion"
let g:EasyMotion_do_mapping=0
let g:EasyMotion_smartcase=1
let g:EasyMotion_use_migemo=1

" EditorConfig "
let g:EditorConfig_exclude_patterns=['fugitive://.*', '\(M\|m\|GNUm\)akefile']

" UltiSnips "
let g:UltiSnipsExpandTrigger='<C-x><C-j>'

" YouCompleteMe "
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
let g:ycm_key_invoke_completion=''
let g:ycm_global_ycm_extra_conf='~/.vim/ycm_extra_conf.py'
let g:ycm_extra_conf_vim_data=[
  \ '&filetype',
  \ 'g:ycm_python_interpreter_path',
  \ 'g:ycm_python_sys_path']

let g:ycm_python_interpreter_path = ''
let g:ycm_python_sys_path = []

if !exists('g:ycm_semantic_triggers')
  let g:ycm_semantic_triggers = {}
endif
if exists('g:vimtex#re#youcompleteme')
  let g:ycm_semantic_triggers.tex = g:vimtex#re#youcompleteme
endif

" airline "
let g:airline_skip_empty_sections=1
if $USE_POWERLINE
  let g:airline_powerline_fonts=1
endif

" markbar "
let g:markbar_enable_peekaboo=v:false

" undotree "
let g:undotree_WindowLayout=2

".vimrcの最後に書くおまじない
filetype plugin indent on
syntax enable
