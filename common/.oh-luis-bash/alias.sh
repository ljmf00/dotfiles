#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

# ===============================
#              ALIAS
# ===============================

# Common directories functions
alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias ......='../../../../..'
alias cd..='cd ..'                         # Go back 1 directory level (for fast typers)
alias .3='cd ../../..'                     # Go back 3 directory levels
alias .4='cd ../../../..'                  # Go back 4 directory levels
alias .5='cd ../../../../..'               # Go back 5 directory levels
alias .6='cd ../../../../../..'            # Go back 6 directory levels

alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

# Directory management
alias md='mkdir -p'
alias rd='rmdir'

# List directory contents
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias lsa='ls -lah'

# Git
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glgp='git log --stat -p'
alias glo='git log --oneline --decorate'
alias glod='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'\'
alias glods='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'\'' --date=short'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glol='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'
alias glola='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --all'
alias glols='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --stat'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbs='git rebase --skip'
alias grev='git revert'
alias grh='git reset'
alias grhh='git reset --hard'
alias grm='git rm'
alias grmc='git rm --cached'
alias grmv='git remote rename'
alias groh='git reset origin/$(git_current_branch) --hard'
alias grrm='git remote remove'
alias grs='git restore'
alias grset='git remote set-url'
alias grup='git remote update'
alias grv='git remote -v'
alias gsh='git show'
alias gsi='git submodule init'
alias gsps='git show --pretty=short --show-signature'
alias gss='git status -s'
alias gst='git status'
alias gsta='git stash push'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gswc='git switch -c'

# Visual Studio Code
alias vsc='code-oss .'
alias vsca='code-oss --add'
alias vscd='code-oss --diff'
alias vscde='code-oss --disable-extensions'
alias vsced='code-oss --extensions-dir'
alias vscg='code-oss --goto'
alias vscie='code-oss --install-extension'
alias vscl='code-oss --log'
alias vscn='code-oss --new-window'
alias vscr='code-oss --reuse-window'
alias vscu='code-oss --user-data-dir'
alias vscue='code-oss --uninstall-extension'
alias vscv='code-oss --verbose'
alias vscw='code-oss --wait'

# Misc
alias waka='npx waka'
alias v='nvim'
alias bashconfig='$EDITOR ~/.bashrc'
alias cls='printf "\033c"'
alias ccat='pygmentize -g'
alias lccat='pygmentize -g -O style=colorful,linenos=1'
alias please='sudo'

# Fancy dir alias
function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -10
  fi
}
