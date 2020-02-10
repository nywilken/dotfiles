reup() {
  git checkout master && git fetch && git pull origin master
}

## Custom history command
h() { if [ -z "$*" ]; then history 1; else history 1 | egrep "$@"; fi; }

alias hist='h'
alias reload!='. ~/.zshrc'
alias ls='ls --color=tty'
alias grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias ack='ack  --ignore-dir={.git,vendor,.vagrant}'
alias tmux='tmux -2'

