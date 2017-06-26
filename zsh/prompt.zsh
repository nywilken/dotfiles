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

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null | wc -l
}

commits_behind() {
  $git rev-list ...@ >/dev/null 2>&1 | wc -l
}

need_push () {
  local commits=$(unpushed)
  if [[ $commits == 0 ]]
  then
   echo "0"
  else
    echo "%{$fg_bold[magenta]%}+%{$reset_color%}$commits"
  fi
}

needs_sync () {
  local commits=$(commits_behind)
  if [[ $commits == 0 ]]
  then
   echo "0"
  else
    echo "%{$fg_bold[magenta]%}-%{$reset_color%}$commits"
  fi
}

commit_status() {
  local status_line="($(needs_sync)/$(need_push))"
  if [[ $status_line == "(0/0)" ]]
  then
    echo ""
  else
    echo " $status_line"
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


directory_name() {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

running_jobs() {
  local job_count=$(jobs | grep '^\[' | wc -l)
  echo "%{$fg_bold[magenta]%}[$job_count]%{$reset_color%}"
}

cpu_util() {
  local utilization=$(iostat -c | grep -v '^[a-zA-Z]' | grep '[0-9]' | awk '{print int($1+0.5)}')
  local color=blue

  if [ $utilization -gt 60 ]
  then
    color=red
  fi
  echo "%{$fg_bold[$color]%}[$utilization]%{$reset_color%}"
}

prompt_status_bar(){
  local timestamp=$(date +'%r')
  echo "%{$fg_bold[grey]%}$timestamp $(running_jobs)$(cpu_util)%{$reset_color%}"
}

export PROMPT=$'\n$(prompt_status_bar) $(rb_prompt) in $(directory_name) $(git_dirty)$(commit_status)\n› '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
