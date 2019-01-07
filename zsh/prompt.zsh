# autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  st=$($git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ""
  else
    if [[ "$st" =~ ^nothing ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

commit_status() {
  st=$(git status -sb --porcelain 2>/dev/null | cut -d' ' -f3,4,5,6 | grep '\[' | sed 's/[^a-z 0-9,]*//g')
  if ! [[ -z "$st" ]]
  then
    echo " ($st)"
  else
    echo ""
  fi
}

ruby_version() {
  if (( $+commands[rbenv] ))
  then
    echo "$(rbenv version | awk '{print $1}')"
  fi

  if (( $+commands[rvm-prompt] ))
  then
    echo "$(rvm-prompt | awk '{print $1}')"
  fi
}

rb_prompt() {
  if ! [[ -z "$(ruby_version)" ]]
  then
    echo "%{$fg_bold[yellow]%}$(ruby_version)%{$reset_color%}"
  else
    echo ""
  fi
}

go_version() {
  echo "$(go version | awk '{print $3}')" | sed 's/^go/go-/g'
}


go_prompt() {
  if ! [[ -z "$(go_version)" ]]
  then
    echo "%{$fg_bold[yellow]%}[$(go_version)]%{$reset_color%}"
  else
    echo ""
  fi
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%0~%\/%{$reset_color%}"
}

running_jobs() {
  jc=$(jobs | grep '^\[' | wc -l | awk '{print $1}')
  echo "%{$fg_bold[magenta]%}[$jc]%{$reset_color%}"
}

cpu_util() {
  if [[ "$(uname -a | awk '{print $1}')" =~ ^Darwin ]]
  then
    echo ""
  else
    ut=$(iostat -c | grep -v '^[a-zA-Z]' | grep '[0-9]' | awk '{print int($1+0.5)}')
    c=blue

    if [ $ut -gt 60 ]
    then
      c=red
    fi
    echo "%{$fg_bold[$c]%}[$ut]%{$reset_color%}"
  fi
}

prompt_status_bar(){
  echo "$(go_prompt) $(running_jobs) $(whoami)%{$reset_color%}"
}

export PROMPT=$'\n$(prompt_status_bar) in $(directory_name) $(git_dirty)$(commit_status)
> '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}[%h] %{$reset_color%}"
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
