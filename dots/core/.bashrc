#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

#
# ~/.bashrc
#

###############################################################################
# NON INTERACTIVE ENVIRONMENT
###############################################################################

mkdir -p "$HOME/.local/bin/" || :

if [ -d "$HOME/.local/bin" ]; then
    # Add .local/bin/ to PATH
    export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.local/share/dotfiles/busybox/bin" ]; then
    # Add busybox tools
    export PATH="$PATH:$HOME/.local/share/dotfiles/busybox/bin"
fi

if \hash npm 2>/dev/null; then
    export NODE_PATH="$HOME/.local/share/dotfiles/node_modules:/usr/local/lib/node_modules:/usr/lib/node_modules"
    mkdir -p "$HOME/.local/share/dotfiles/node_modules/.bin" || :

    export PATH="$HOME/.local/share/dotfiles/node_modules/.bin:$PATH"
fi

# ccache configurations
export USE_CCACHE=1
export CCACHE_COMPRESS=1

# Wine
export WINEPREFIX="$HOME/.wine"
export WINEARCH=win64

# Java
if \hash archlinux-java 2>/dev/null; then
    JAVA_HOME="/usr/lib/jvm/$(archlinux-java get)/"
else
    JAVA_HOME="/usr/lib/jvm/default/"
fi
export JAVA_HOME

# Python
if ! \hash pyenv 2>/dev/null && [ -f "$HOME/.pyenv/bin/pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
fi

if \hash pyenv 2>/dev/null; then
    \eval "$(pyenv init -)"
fi

# Android
export ANDROID_HOME=/opt/android-sdk

# jBOSS
export JBOSS_HOME=/opt/wildfly

# set $USER variable
if [ -z "${USER+x}" ]; then
    USER="$(id -u -n)"
    export USER
fi

# Configure editor variables
if [ -f "$HOME/.local/bin/editor" ]; then
    export EDITOR="$HOME/.local/bin/editor"
    export VISUAL="$HOME/.local/bin/editor"
elif \hash nvim 2> /dev/null; then
    export EDITOR='nvim'
    export VISUAL='nvim'
elif \hash vim 2> /dev/null; then
    export EDITOR='vim'
    export VISUAL='vim'
elif \hash vi 2> /dev/null; then
    export EDITOR='vi'
    export VISUAL='vi'
fi

# If not running interactively, don't do anything!
[[ $- != *i* ]] && \return

# Load shell integration script before safe failures as we don't control it.

if [ -f "$HOME/.bash/_term" ]; then
    # shellcheck disable=SC1090
    \source "$HOME/.bash/_term"
fi

# block user input
stty -echo

# set safe failures
\set -euo pipefail

_bashrc_akey_continue() { read -n 1 -s -r -p "Press any key to continue"; }

# trap to interactively exit on failed startup
\trap _bashrc_akey_continue EXIT

# sanity check for bash 4+
(( BASH_VERSINFO[0] < 4 )) && echo "Bash 4+ required." && exit 1

###############################################################################
# INTERACTIVE ENVIRONMENT
###############################################################################

# set $TERM variable if not set
if [ -z ${TERM+x} ]; then
    export TERM=xterm
fi

###############################################################################
# GPG
###############################################################################

GPG_TTY="$(tty)"
export GPG_TTY

if hash gpgconf 2> /dev/null; then
	if ! pgrep -u "$USER" gpg-agent >/dev/null 2>&1; then
		gpgconf --launch gpg-agent
	fi

	if ! pgrep -u "$USER" dirmngr >/dev/null 2>&1; then
		gpgconf --launch dirmngr
	fi

    if [[ -z ${SSH_AUTH_SOCK+x} ]] && [[ -f "$HOME/.gnupg/sshcontrol" ]]; then
        export SSH_AGENT_PID=
        SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
        export SSH_AUTH_SOCK
    fi
fi

###############################################################################
# SSH
###############################################################################

if [[ -z ${SSH_AUTH_SOCK+x} ]]; then
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        ssh-agent -t 15m > "$XDG_RUNTIME_DIR/ssh-agent.env"
    fi

    if [ -f "$XDG_RUNTIME_DIR/ssh-agent.env" ]; then
        source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
    else
        eval "$(ssh-agent -t 15m | tee "$XDG_RUNTIME_DIR/ssh-agent.env")"
    fi
fi

###############################################################################
# BASH AUTO COMPLETE
###############################################################################

# Bash completion
# shellcheck disable=SC1091
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# pkgfile hook
if [ -f "/usr/share/doc/pkgfile/command-not-found.bash" ]; then
	# shellcheck disable=SC1091
	source /usr/share/doc/pkgfile/command-not-found.bash
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found ] || [ -x /usr/share/command-not-found/command-not-found ]; then
        function command_not_found_handle {
                # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
                   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
                   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
                else
                   printf "%s: command not found\n" "$1" >&2
                   return 127
                fi
        }
fi

###############################################################################
# ALIASES
###############################################################################

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

# Videos
alias view-video-144p='mpv --ytdl-format="bestvideo[height<=?144][fps<=?30][vcodec!=?vp9]+bestaudio/best"'
alias view-video-480p='mpv --ytdl-format="bestvideo[height<=?480][fps<=?30][vcodec!=?vp9]+bestaudio/best"'
alias view-video-720p='mpv --ytdl-format="bestvideo[height<=?720][fps<=?60][vcodec!=?vp9]+bestaudio/best"'
alias view-video-1080p='mpv --ytdl-format="bestvideo[height<=?1080][fps<=?60][vcodec!=?vp9]+bestaudio/best"'

# Misc
alias waka='npx waka'
alias v='"$EDITOR"'
alias bashconfig='"$EDITOR" ~/.bashrc'
alias cls='printf "\033c"'
alias ccat='pygmentize -g'
alias lccat='pygmentize -g -O style=colorful,linenos=1'
alias please='sudo'
alias task='dstask'
alias t='dstask'

if \hash perf_ 2>/dev/null; then
  alias perf='perf_'
fi

if \hash lsd 2>/dev/null; then
  alias ls='lsd'
else
  alias ls='ls --color'
fi

# Fancy dir alias
function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -10
  fi
}

# Makes new Dir and jumps inside
mcd () { mkdir -p -- "$*" ; cd -- "$*" || exit ; }

#   mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#           displays paginated result with colored search terms and two lines surrounding each hit.
#           Example: mans mplayer codec
mans () { man "$1" | grep -iC2 --color=always "$2" | less ; }

#   quiet: mute output of a command
quiet () {
    "$*" &> /dev/null &
}

ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
# shellcheck disable=SC2145
ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
# shellcheck disable=SC2145
ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string
bigfind() {
  if [[ $# -lt 1 ]]; then
    echo_warn "Usage: bigfind DIRECTORY"
    return
  fi
  du -a "$1" | sort -n -r | head -n 10
}

#   myip:  displays your ip address, as seen by the Internet
myip () {
  res=$(curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+')
  echo -e "Your public IP is: $res"
}

#   lsgrep: search through directory contents with grep
# shellcheck disable=SC2010
lsgrep () { ls | grep "$*" ; }

# get all possible bash colors matrix
color-matrix() {
	for x in {0..8}; do
	    for i in {30..37}; do
	        for a in {40..47}; do
	            echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "
	        done
	        echo
	    done
	done
	echo ""
}

sqlplus() {
    PRE_TEXT=$(resize |sed -n "1s/COLUMNS=/set linesize /p;2s/LINES=/set pagesize /p"|while read -r line; do printf "%s \ " "$line";done);
    if [ -z "$1" ]; then
        rlwrap -m -P "$PRE_TEXT" sqlplus /nolog;
    else
        if ! echo "$1" | grep '^-' > /dev/null; then
            rlwrap -m -P "$PRE_TEXT connect $*" sqlplus /nolog;
        else
        	# shellcheck disable=SC2048
        	# shellcheck disable=SC2086
            command sqlplus $*;
        fi;
    fi
}

spwd() {
    cwd=$(echo "${PWD/#$HOME/\~}" | perl -F/ -ane 'print join( "/", map { $i++ < @F - 1 ?  substr $_,0,1 : $_ } @F)')
    echo "$cwd"
}

###############################################################################
# BASH OPTIONS
###############################################################################

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
#[[ -n ${DISPLAY+x} ]] && shopt -s checkwinsize || :
shopt -s checkwinsize

# Enable history appending instead of overwriting.
shopt -s histappend

# ingore duplicate entries on the history
export HISTCONTROL="ignoredups,ignorespace"

# history size
export HISTSIZE=50000

# Enable autocd, when no cd is provided witha valid path
shopt -s autocd 2> /dev/null
# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null

# Ignored EOF action on interactive shell

# Value of consecutive EOF characters before exiting
export IGNOREEOF=10

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2> /dev/null

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

###############################################################################
# BINDS
###############################################################################

# up and down keybinds
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# CTRL + left and right keybinds
bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'

# Page up and page down completion navigation
bind '"\e[6~": menu-complete'
bind '"\e[5~": menu-complete-backward'

# partially complete the word and show all possible completions if it is still ambiguous
bind 'set show-all-if-ambiguous on'
# completion will ignore case when doing partial completion
bind 'set completion-ignore-case on'
# The double tab will be changed to a single tab when unmodified
bind 'set show-all-if-unmodified on'
# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"
# Immediately add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"

# Color files by types
bind 'set colored-stats On'
# Append char to indicate type
bind 'set visible-stats On'
# Mark symlinked directories
bind 'set mark-symlinked-directories On'
# Color the common prefix
bind 'set colored-completion-prefix On'
# Color the common prefix in menu-complete
bind 'set menu-complete-display-prefix On'

# run help
bind -m vi-insert -x '"\eh": run-help'
bind -m emacs -x     '"\eh": run-help'

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# dont trigger bell when TAB
bind 'set bell-style none'

# from /etc/inputrc
bind 'set meta-flag on'
bind 'set input-meta on'
bind 'set convert-meta off'
bind 'set output-meta on'

###############################################################################
# COLORS
###############################################################################

# define set_windowtitle and ncolors as early as possible
case "$TERM" in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*|linux*|tmux*)
        ncolors="$(tput colors)"
        ;;
    *)
        ncolors=0
        ;;
esac

if test -n "$ncolors" && test "$ncolors" -ge 8; then
    # add termcap for less when colors are available
    export LESS=-FSR
    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    if hash dircolors 2> /dev/null; then
        eval "$(dircolors -b ~/.dircolors)"
    fi
fi

# set true color for micro editor
if [ -n "${COLORTERM+x}" ] && [ "$COLORTERM" == "truecolor" ] && hash micro 2> /dev/null; then
    MICRO_TRUECOLOR=1
    export MICRO_TRUECOLOR
fi

# If there's goto command, source it
if [ -f "$HOME/.bash/goto" ]; then
  # shellcheck disable=SC1090
  source "$HOME/.bash/goto"
fi

###############################################################################

# reenable input
stty echo

# reenable bash failures
set +euo pipefail

# untrap exit
trap - EXIT

###############################################################################
# PROMPT
###############################################################################

# define set_windowtitle and ncolors as early as possible
case "$TERM" in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*|linux*|tmux*)
        _bashrc_set_windowtitle() {
            echo -ne "\033]0;$*\007"
        }
        ;;
    *)
        _bashrc_set_windowtitle() {
            :
        }
        ;;
esac

if \hash starship 2>/dev/null; then
    \eval "$(starship init bash)"

    starship_precmd_user_func="_bashrc_set_windowtitle"
fi

###############################################################################

if [ -f "$HOME/.bashrc-extended" ]; then
    # shellcheck disable=SC1090
    \source "$HOME/.bashrc-extended"
fi
