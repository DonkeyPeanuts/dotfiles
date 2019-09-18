#!/usr/bin/env bash

DOTFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DOTFILE_DIR/scripts/setup"

# Remove dead symlinks
@clean
  - gc: "${ENABLE_GC:-true}"
  # the rest of this section is kept for backwards compatibility
  - .gitconfig
  - .latexmkrc
  - .vimrc
  - .gvimrc
  - .config/shell/common.snip
  - .mikutter/plugin
  - .nixpkgs/config.nix

@install Update Submodules
  - shell: git submodule update --init --remote

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
  - .local/share/zsh/plugins

@install Install Vim Config
  - .vim
  - .config/nvim

@install Install Git Config
  - .config/git/config
  - .config/git/ignore
  - .config/tig/config
  - .local/bin/git-fancy

@install Install GDB Config
  - .gdbinit
  - .local/bin/gef
  - .local/bin/peda
  - .local/bin/pwndbg

@install Install LaTeX Config
  - .config/latexmk/latexmkrc
  - .local/bin/platexmk
  - .local/bin/uplatexmk

@install Install Miscellaneous Config
  - .clang-format
  - .editrc
  - .ideavimrc
  - .config/bat/config
  - .config/nano/nanorc
  - .config/nixpkgs/config.nix
  - .config/ranger/rc.conf
  - .config/ranger/scope.sh
  - .config/tilix/schemes/gruvbox-dark.json
  - .config/zathura/zathurarc
  - .ipython/profile_default/ipython_config.py
  - .local/libexec/fzf/install
  - .local/opt/fzftools
  - .local/opt/tmux-copycat
  - .screenrc
  - .tern-config
  - .tmux.conf
  - .wgetrc
  - .xprofile
  - .xmonad

# Will not run unless --install-deps is specified
@packages
  - skip: "${SKIP_PACKAGES:-true}"
  - cmake
