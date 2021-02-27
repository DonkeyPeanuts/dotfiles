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
  - .config/shell/snippets/common
  - .config/shell/snippets/linux
  - .config/shell/templates
  - .config/shell/templates.csv
  - .local/share/zsh/site-functions
  - .local/share/zsh/plugins/cf-zsh-autocomplete-plugin
  - .local/share/zsh/plugins/zsh-completions
  - .local/share/zsh/plugins/zsh-syntax-highlighting 
  - .local/share/git

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
  - .Xresources

# The below will not run unless --init is specified

@githooks
  - init: true
  - post-receive
