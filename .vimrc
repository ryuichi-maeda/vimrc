" setting
"文字コードをUFT-8に設定
set fenc=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd
" バックスペースキーの有効化
set backspace=indent,eol,start


" 見た目系
" 行番号を表示
set number
" 相対的な行番号を表示
set relativenumber
" 現在の行を強調表示
set cursorline
" 現在の行を強調表示（縦）
" set cursorcolumn
" 行末の1文字先までカーソルを移動できるように
" set virtualedit=onemore
" 改行前に，前の行のインデントを継続
set autoindent
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" カーソルの左右異動で行末，行頭の移動を可能にする
set whichwrap=b,s,h,l,<,>,[,],~
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
" シンタックスハイライトの有効化
syntax enable
" colorscheme delek
set background=dark

" キーマップ


" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=4
" 行頭でのTab文字の表示幅
set shiftwidth=4


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>


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
    set termguicolors
  endif
endif


" リーダーキー
" リーダーキーを「,」に設定
let mapleader = "\<Space>"
" .vimrcファイルが垂直分割ウィンドウで開く
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>

" カーソル
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" マウス有効化
if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif

" クリップボードからのペースト時のインデント制御
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

" 空行処理
function! CleanUpFile()
    " 最終行が空白のみか確認
    if getline('$') =~# '^\s*$'
        " 最終行が空白のみの場合、それを空行にする
        call setline('$', '')
    else
        " 最終行に何か文字がある場合、空行を追加
        call append('$', '')
    endif

    " 他の行で何も文字が書かれていなければ、空行にする
    %s/^\s\+$//e
    " %s/^\s\+$/\r/
endfunction


autocmd BufWritePre * call CleanUpFile()

" NeoBundle
if has('vim_starting')
    " 初回起動時のみruntimepathにNeoBundleのパスを指定する
    set runtimepath+=~/.vim/bundle/neobundle.vim/

    " NeoBundleが未インストールであればgit cloneする・・・・・・①
    if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
        echo "install NeoBundle..."
        :call system("git clone git@github.com:Shougo/neobundle.vim.git ~/.vim/bundle/neobundle.vim")
    endif
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" インストールするVimプラグインを以下に記述
" NeoBundle自身を管理
NeoBundleFetch 'Shougo/neobundle.vim'
"----------------------------------------------------------
" ここに追加したいVimプラグインを記述する・・・・・・②
" ステータスラインの表示内容強化
NeoBundle 'itchyny/lightline.vim'

" 空白文字の可視化
NeoBundle 'bronson/vim-trailing-whitespace'
" インデントの可視化
NeoBundle 'Yggdroot/indentline'

" 多機能セレクタ
NeoBundle 'ctrlpvim/ctrlp.vim'
" CtrlPの拡張プラグイン. 関数
NeoBundle 'tacahiroy/ctrlp-funky'
" CtrlPの拡張プラグイン. コマンド履歴検索
NeoBundle 'suy/vim-ctrlp-commandline'

" Color Scheme
" Onedark
" NeoBundle 'joshdick/onedark.vim'
" Tokyo Night
" NeoBundle 'ghifarit53/tokyonight-vim'
" Sonokai
NeoBundle 'sainnhe/sonokai'
" Solarized8
" NeoBundle 'lifepillar/vim-solarized8'

"----------------------------------------------------------
call neobundle#end()

" ファイルタイプ別のVimプラグイン/インデントを有効にする
filetype plugin indent on

" 未インストールのVimプラグインがある場合、インストールするかどうかを尋ねてくれるようにする設定・・・・・・③
NeoBundleCheck

"----------------------------------------------------------
" インストールしたプラグインの設定
" ステータスラインの表示内容強化
set showmode
set ruler

" CtrlPの設定
let g:ctrlp_match_window = 'order:ttb,min:20,max:20,results:100' " マッチウインドウの設定. 「下部に表示, 大きさ20行で固定, 検索結果100件」
let g:ctrlp_show_hidden = 1 " .(ドット)から始まるファイルも検索対象にする
let g:ctrlp_types = ['fil'] "ファイル検索のみ使用
let g:ctrlp_extensions = ['funky', 'commandline'] " CtrlPの拡張として「funky」と「commandline」を使用

" CtrlPCommandLineの有効化
command! CtrlPCommandLine call ctrlp#init(ctrlp#commandline#id())

" CtrlPFunkyの有効化
let g:ctrlp_funky_matchtype = 'path'

" Tokyo Night theme
set termguicolors
" let g:tokyonight_style = 'night'
" let g:tokyonight_enable_italic = 1
" let g:tokyonight_transparent_background = 0
" let g:lightline = {'colorscheme' : 'tokyonight'}
" let g:airline_theme = 'tokyonight'
" colorscheme tokyonight

" Sonokai theme
let g:sonokai_style='atlantis'
let g:sonokai_disable_italic_comment=0
let g:sonokai_transparent_background=1
let g:sonokai_diagnostic_test_highlight=1
let g:sonokai_diagnostic_line_highlight=1
let g:lightline = {'colorscheme' : 'sonokai'}
let g:airline_theme = 'sonokai'
colorscheme sonokai

" Solarized8
" let g:solarized_visibility='normal'
" let g:solarized_statusline='flat'
" let g:solarized_termtrans=1
" colorscheme solarized8

