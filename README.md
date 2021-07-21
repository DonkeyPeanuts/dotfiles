# dotfiles

個人的な dotfile 置き場

## Installation

### Step 0: 依存パッケージのインストール

下記と下記の依存パッケージは事前にインストール ( Ubuntu や macOS では brew 等で install )

- ssh
- git
- zsh
- tmux
- vim
- nvim
- bash-completion
- bat
- tig
- git-delta

### Step 1: git設定

`master` ブランチのまま `home/.config/git/config` のユーザ設定とメールアドレスを埋める。

```console
$ git clone --recursive https://github.com/${USER}/dotfiles.git
$ cd dotfiles
$ vim home/.config/git/config

[user]
 name = "John Doe"
 email = john@example.com
...

$ export GIT_AUTHOR_NAME="John Doe"
$ export GIT_COMMITTER_NAME="John Doe"
$ export EMAIL="john@example.com"
$ git commit -am 'replace profile information'
```

### Step 2: ローカル用のブランチ作成

用途別のブランチに checkout して `local` のようなローカル用のbranchを切る。
(下の例では worktree を使って `~/.config/dotfiles` 以下に置いている。)

```console
git checkout minimum
git merge master  # merge changes from Step 1
git branch --track local  # create local branch
git worktree add ~/.config/dotfiles local  # checkout local branch
```

### Step 3: セットアップ用スクリプトの実行

`setup.sh` を走らせて設定ファイルを配置。
`ローカルブランチ(~/.config/dotfiles)` 配下で変更がある度に走らせる。

```console
cd ~/.config/dotfiles
./setup.sh
```

## Uninstallation

削除したり入れ直したいときは設定ファイルを吹き飛ばす(他のパッケージ等の設定が入っている場合は注意)

```console
rm -rf ~/.config ~/.local
cd ${cloneした作業ディレクトリ}
git worktree prune
git branch -D ${ローカル用ブランチ}
```

## Misc

### submodule 更新

```console
git submodule update --remote
```

### anyenv で必要なenvのinstall

```console
anyenv init
anyenv install rbenv
anyenv install pyenv
anyenv install nodenv
anyenv install goenv
anyenv install plenv
exec $SHELL -l

mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
git clone https://github.com/znz/anyenv-git.git $(anyenv root)/plugins/anyenv-git

mkdir -p "$(nodenv root)"/plugins
git clone https://github.com/nodenv/node-build-update-defs.git "$(nodenv root)"/plugins/node-build-update-defs

cd "$(rbenv root)"
src/configure && make -C src
rbenv init
```

### neovim with python3の設定

適当なバージョンを入れてpipでneovimを入れておく

```console
mkdir -p "$(pyenv root)"/plugins
git clone https://github.com/yyuu/pyenv-virtualenv $(pyenv root)/plugins/pyenv-virtualenv
git clone https://github.com/yyuu/pyenv-ccache $(pyenv root)/plugins/pyenv-ccache
git clone https://github.com/massongit/pyenv-pip-update $(pyenv root)/plugins/pyenv-pip-update
pyenv install 3.9.6
pyenv virtualenv 3.9.6 neovim-3
pyenv shell neovim-3
pip3 install neovim pynvim
```
