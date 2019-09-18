# シェル生成の度に読み込まれる
# prompt
PS1='\[\033[32m\]($(date +%Y-%m-%d_%H:%M:%S))\[\033[00m\]\[\033[34m\][\h @ \u]\[\033[00m\]\[\033[33m\]:\n\w\[\033[00m\]\$ '

# alias
alias l='ls -tF --color=auto'
alias ls='ls -tF --color=auto'
alias ll='ls -ltF --color=auto'
alias la='ls -atF --color=auto'
alias lla='ls -altF --color=auto'
alias lld='ls -altFd --color=auto'

alias grep='grep --color=auto'
alias df='df -h'
#alias ps='ps --sort=start_time'
alias sc='screen -D -U -RR'
alias hn='hostname'

# for root
if test "$UID" == 0; then
    alias mv='mv -i'
    alias cp='cp -i'
    alias rm='rm -i'
fi

# share history
function share_history
{
    history -a
    history -c
    history -r
}
PROMPT_COMMAND='share_history'
shopt -u histappend
shopt -s cmdhist

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
