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

alias vim="nvim"
alias vi="nvim"
alias oldvim="vim"

new-thing() {
  pushd ~/Documents/gsd
  hub issue create -m $1 -l $2
  popd
}
complete-thing() {
  pushd ~/Documents/gsd
  hub issue update $1 -l done -s closed
  popd
}
read-thing() {
  pushd ~/Documents/gsd
  hub issue show $1 | less
  popd
}
thing-report() {
  DATEFILTER=$(date --date="-1 day" -I)
  if [ ! -z $1 ];
  then
    DATEFILTER=$(date --date="-1 month" -I)
  fi

  pushd ~/Documents/gsd
  echo "Things Completed"
  hub issue -l done -s closed -d $DATEFILTER -f "(%I) * %t%n"
  echo "Things Up Next"
  hub issue -l today, next -f "(%I) * %t%n"
  popd

}

