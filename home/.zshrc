# 色有効化
autoload -Uz colors && colors # black red green yellow blue magenta cyan white

# hookの設定
autoload -Uz add-zsh-hook

typeset -U path PATH

bindkey -e
########################################
# completion周りの設定
########################################
fpath=(.local/share/zsh/site-functions $fpath)
if [ -e .local/share/zsh-completions ]; then
  fpath=(.local/share/zsh-completions $fpath)
fi

autoload -Uz compinit
if [[ -f ~/.zcompdump(#qN.m+1) ]]; then
  compinit -u
else
  compinit -C
fi

setopt nonomatch

# 補完候補に色つける
zstyle ':completion:*' list-colors "${LS_COLORS}"

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# 単語の入力途中でもTab補完を有効化
setopt complete_in_word

# 補完候補をハイライト
zstyle ':completion:*:default' menu select=1

# キャッシュの利用による補完の高速化
zstyle ':completion::complete:*' use-cache true

# 補完リストの表示間隔を狭くする
setopt list_packed
 
# コマンドの打ち間違いを指摘してくれる
setopt correct
SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [Yes/No/Abort/Edit] => "

# 不完全な補完
setopt always_to_end

# コマンドラインの引数でも補完を有効にする
setopt magic_equal_subst

# 展開する前に補完候補を出させる
setopt menu_complete

zmodload -i zsh/complist

########################################
# prompt周りの設定
# @TODO 今の所やりたいこと
# - cvs対応
# - ssh中のみホスト名表示
########################################
# VCSの情報を取得するzsh関数
autoload -Uz promptinit && promptinit
autoload -Uz vcs_info

# PROMPT変数内で変数参照
setopt prompt_subst

zstyle ':vcs_info:git:*' check-for-changes true #formats 設定項目で %c,%u が使用可
zstyle ':vcs_info:git:*' stagedstr "%F{green}!" #commit されていないファイルがある
zstyle ':vcs_info:git:*' unstagedstr "%F{magenta}+" #add されていないファイルがある
zstyle ':vcs_info:*' formats "%F{cyan}%c%u(%b)%f" #通常
zstyle ':vcs_info:*' actionformats '[%b|%a]' #rebase 途中,merge コンフリクト等 formats 外の表示
zstyle ':vcs_info:*' enable git cvs

# %b ブランチ情報
# %a アクション名(mergeなど)
# %c changes
# %u uncommit

__update_term() {

  vcs_info

  local user='%n'
  if [[ -n "$SSH_CONNECTION" ]]; then
    user='%n@%m'
  fi

  local left=" %{\e[38;5;4m%}[${user}]${vcs_info_msg_0_}%{\e[m%}"

  local right="%{\e[38;5;3m%}(%~)%{\e[m%}"
  # スペースの長さを計算
  # テキストを装飾する場合、エスケープシーケンスをカウントしない
  local invisible='%([BSUbfksu]|([FK]|){*})'
  local leftwidth=${#${(S%%)left//$~invisible/}}
  local rightwidth=${#${(S%%)right//$~invisible/}}
  local padwidth=$(($COLUMNS - ($leftwidth + $rightwidth) % $COLUMNS))

  # print -P $left${(r:$padwidth:: :)}$right
  print -P $left$right
}

add-zsh-hook precmd __update_term

# プロンプト（左）
PROMPT='$'

# プロンプト（右）
RPROMPT=$'%{\e[38;5;251m%}%D{%b %d}, %*%{\e[m%}'

########################################
# alias周りの設定
# @TODO linuxとmacどちらでも使えるようにする
########################################
alias l='ls -tF --color=auto'
alias ls='ls -tF --color=auto'
alias ll='ls -ltF --color=auto'
alias la='ls -atF --color=auto'
alias lla='ls -altF --color=auto'
alias lld='ls -altFd --color=auto'

alias df='df -h'
alias sc='screen -D -U -RR'
alias hn='hostname'

alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'

alias history='history -i'

########################################
# history共有周りの設定
########################################
function history-all { history -E 1 }
# プロセスを横断してヒストリを共有
# ヒストリの共有の有効化
setopt share_history

# 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups

# history search
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups

# スペースで始まるコマンド行はヒストリリストから削除
setopt hist_ignore_space

# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify

# 余分な空白は詰めて記録
setopt hist_reduce_blanks  

# 古いコマンドと同じものは無視 
setopt hist_save_no_dups

# historyコマンドは履歴に登録しない
setopt hist_no_store

# 履歴をインクリメンタルに追加
setopt inc_append_history
# インクリメンタルからの検索
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

# history 拡張
setopt extended_history

setopt hist_expire_dups_first
########################################
# その他
# @TODO 必要になったら編集
########################################
# shellで<back space>効かないとき用
if test -t 0; then
	stty stop undef
	stty erase "^H"
fi

# 単語の区切り文字を指定する
autoload -Uz select-word-style && select-word-style default

# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# '#' 以降をコメントとして扱う
setopt interactive_comments

# cd したら自動的にpushdする
setopt auto_pushd

setopt auto_name_dirs

# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 高機能なワイルドカード展開を使用する
setopt extended_glob
# 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs

# リダイレクトによる上書き禁止
setopt no_clobber

# 再コンパイル設定
autoload -Uz zrecompile && zrecompile -p -R ~/.zshrc -- -M ~/.zcompdump &!
autoload -Uz url-quote-magic && zle -N self-insert url-quote-magic

export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

export GO_ROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin

export RBENV_ROOT=$HOME/.local/share/opt/rbenv/
export PATH=$PATH:$RBENV_ROOT/bin

export PYENV_ROOT=$HOME/.local/share/opt/pyenv
export PATH=$PATH:$PYENV_ROOT/bin
eval "$(pyenv init -)"

if [ -f ~/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets)
fi

[ -f ~/.local/share/git/git-completion.zsh ] && source ~/.local/share/git/git-completion.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh