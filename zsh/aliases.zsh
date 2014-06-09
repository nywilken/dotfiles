reup() {
  git checkout master && git fetch && git pull origin master
}

## Custom history command
h() { if [ -z "$*" ]; then history 1; else history 1 | egrep "$@"; fi; }

alias hist='h'
alias reload!='. ~/.zshrc'

