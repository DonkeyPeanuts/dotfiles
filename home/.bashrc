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

unset LS_COLORS # clear distro defaults

# prompt
PS1='\[\033[32m\]($(date +%Y-%m-%d_%H:%M:%S))\[\033[00m\]\[\033[34m\][\h @ \u]\[\033[00m\]\[\033[33m\]:\n\w\[\033[00m\]\$ '


###########################
#  Environment Variables  #
###########################
export GPG_TTY="$(tty)"

PATH="$HOME/.local/bin:$PATH"
PATH+=":$GEM_HOME/bin"
PATH+=":$(python3 -c 'import site; print(site.getuserbase())')/bin"
PATH+=":$GOPATH/bin"
export PATH

###########################
#  Aliases and Functions  #
###########################
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias l='ls -tF --color=auto'
alias ls='ls -tF --color=auto'
alias ll='ls -ltF --color=auto'
alias la='ls -atF --color=auto'
alias lla='ls -altF --color=auto'
alias lld='ls -altFd --color=auto'
alias grep='grep --color=auto'
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

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

source ~/.local/opt/fzftools/fzftools.bash

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

if [ -f ~/.local/share/etc/bash-completion ]; then
    source ~/.local/share/etc/bash_completion
fi
if [ -f ~/.local/share/git/git-completion.bash ]; then
    source ~/.local/share/git/git-completion.bash
fi
if [ -f ~/.local/share/git/git-prompt.sh ]; then
    source ~/.local/share/git/git-prompt.sh
    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWUNTRACKEDFILES=true
    export PS1='\[\033[32m\]($(date +%Y-%m-%d_%H:%M:%S))\[\033[00m\]\[\033[34m\][\h @ \u]\[\033[00m\]\[\033[33m\]:\n\w\[\033[00m\]\[\033[35m\]$(__git_ps1 [%s])\[\033[00m\]\$ '
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash