##########################
#  Early Initialization  #
##########################

export EDITOR="vim"
export LANG="en_US.UTF-8"
export LESS="iMR"
export PAGER="less"
export SYSTEMD_LESS="iRSMK"

# whether to make use of powerline fonts
export USE_POWERLINE=0
[[ -z "$DISPLAY$WAYLAND_DISPLAY$SSH_CONNECTION" ]] && USE_POWERLINE=0

# skip the rest for non-interactive sessions
case $- in
  *i*) ;;
  *) return ;;
esac

###########
#  Theme  #
###########
if [[ $TERM == "dumb" ]]; then
  PS1='\u@\h:\w\$ '
  return
fi

# clear distro defaults
unset LS_COLORS

# prompt
PS1='\[\033[32m\]($(date +%Y-%m-%d_%H:%M:%S))\[\033[00m\]\[\033[34m\][\h @ \u]\[\033[00m\]\[\033[33m\]:\n\w\[\033[00m\]\$ '


###########################
#  Aliases and Functions  #
###########################
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

case "${OSTYPE}" in
darwin*)
  alias l='ls -tF -G'
  alias ls='ls -tF -G'
  alias ll='ls -ltF -G'
  alias la='ls -atF -G'
  alias lla='ls -altF -G'
  alias lld='ls -altFd -G'
  ;;
linux*)
  alias l='ls -tF --color=auto'
  alias ls='ls -tF --color=auto'
  alias ll='ls -ltF --color=auto'
  alias la='ls -atF --color=auto'
  alias lla='ls -altF --color=auto'
  alias lld='ls -altFd --color=auto'
  ;;
esac

alias df='df -h'
alias sc='screen -D -U -RR'
alias hn='hostname'

# for root
if test "$UID" == 0; then
    alias mv='mv -i'
    alias cp='cp -i'
    alias rm='rm -i'
fi

#############
#  History  #
#############
function share_history
{
    history -a
    history -c
    history -r
}
PROMPT_COMMAND='share_history'
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s cmdhist
shopt -s lithist
shopt -s histappend

##########
#  Misc  #
##########
shopt -s checkjobs
shopt -s checkwinsize
shopt -s globstar
stty -ixoff -ixon # disable flow control

command -v lesspipe >/dev/null 2>&1 && eval "$(SHELL=/bin/sh lesspipe)"

# Report the working directory
case "$TERM" in
  xterm*|screen*|tmux*)
    __vte_urlencode() {
      # Use LC_CTYPE=C to process text byte-by-byte.
      local LC_CTYPE=C LC_ALL= raw_url="$1" safe
      while [[ -n "$raw_url" ]]; do
        safe="${raw_url%%[!a-zA-Z0-9/:_\.\-\!\'\(\)~]*}"
        printf "%s" "$safe"
        raw_url="${raw_url#"$safe"}"
        if [[ -n "$raw_url" ]]; then
          printf "%%%02X" "'$raw_url"
          raw_url="${raw_url#?}"
        fi
      done
    }

    __vte_osc7() {
      printf "\e]7;file://%s%s\a" "${HOSTNAME:-}" "$(__vte_urlencode "$PWD")"
    }

    PROMPT_COMMAND="__vte_osc7;$PROMPT_COMMAND"
    ;;
esac

# test
# shellで<back space>効かないとき用
if test -t 0; then
    stty stop undef
    stty erase "^H"
fi


###########################
#  Environment Variables  #
###########################
export GPG_TTY="$(tty)"

# @TODO Change according to your environment
export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

# @TODO Change according to your environment
export ANYENV_ROOT=$HOME/.local/opt/anyenv
export PATH=$ANYENV_ROOT/bin:$PATH
export ANYENV_DEFINITION_ROOT=$ANYENV_ROOT-install

export GOENV_ROOT=$HOME/.local/opt/anyenv/envs/goenv
export PATH=$GOENV_ROOT/bin:$PATH
eval "$(goenv init -)"
export PATH=$GOROOT/bin:$PATH
export PATH=$PATH:$GOPATH/bin

export NODENV_ROOT=$HOME/.local/opt/anyenv/envs/nodenv
export PATH=$NODENV_ROOT/bin:$PATH
eval "$(nodenv init -)"

export PLENV_ROOT=$HOME/.local/opt/anyenv/envs/plenv
export PATH=$PATH:$PLENV_ROOT/bin
eval "$(plenv init -)"

export PYENV_ROOT=$HOME/.local/opt/anyenv/envs/pyenv
export PATH=$PATH:$PYENV_ROOT/bin
eval "$(pyenv init -)"

export RBENV_ROOT=$HOME/.local/opt/anyenv/envs/rbenv/
export PATH=$PATH:$RBENV_ROOT/bin

# @TODO Change according to your environment
[ -f $(brew --prefix)/etc/profile.d/bash-completion.bash ] && source $(brew --prefix)/etc/profile.d/bash_completion.bash

[ -f ~/.local/share/git/git-completion.bash ] && source ~/.local/share/git/git-completion.bash

if [ -f ~/.local/share/git/git-prompt.sh ]; then
    source ~/.local/share/git/git-prompt.sh
    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWUNTRACKEDFILES=true
    export PS1='\[\033[32m\]($(date +%Y-%m-%d_%H:%M:%S))\[\033[00m\]\[\033[34m\][\h @ \u]\[\033[00m\]\[\033[33m\]:\n\w\[\033[00m\]\[\033[35m\]$(__git_ps1 [%s])\[\033[00m\]\$ '
fi

# @TODO Change according to your environment
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
