#!/usr/bin/env bash
# shellcheck disable=SC2215

DOTFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/setup
source "$DOTFILE_DIR/scripts/setup"

# Remove dead symlinks
@clean
  - gc: true

@shell Update Submodules
  - git submodule --quiet update --init --remote

@install Install Shell Config
  - .bash_profile
  - .bashrc
  - .bash_logout
  - .zshenv
  - .zshrc
  - .zlogout
  - .inputrc
  - .config/shell/snippets/common.snip
  - .config/shell/snippets/linux.snip
  - .config/shell/templates
  - .config/shell/templates.csv
  - .local/share/zsh/site-functions
  - .local/share/zsh/plugins/zsh-completions
  - .local/share/zsh/plugins/zsh-syntax-highlighting 
  - .local/share/git

@shell Update git scripts
  - curl -o .local/share/git/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
  - curl -o .local/share/git/git-completion.zsh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
  - curl -o .local/share/git/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

@install Install Vim Config
  - .vim
  - .config/nvim

@install Install Git Config
  - .config/git/attributes
  - .config/git/config
  - .config/git/ignore

@install Install SSH Config
  - shell: install -d -m 700 ~/.ssh ~/.ssh/sockets
  - chmod: 700 .ssh
  - .ssh/config
  - .ssh/config.d/10-canonicalize.conf
  - .ssh/config.d/80-git.conf
  - .ssh/config.d/90-general.conf
  - .ssh/config.d/90-multiplexing.conf

@install Install Miscellaneous Config
  - .clang-format
  - .editrc
  - .local/opt/tmux-copycat
  - .local/opt/pyenv
  - .local/opt/rbenv
  - .tmux.conf
  - .wgetrc
  - .xprofile
