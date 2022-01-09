#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

#
# ~/.bashrc
#

# ===============================
#           ENVIRONMENT
# ===============================

# ccache configurations
export USE_CCACHE=1
export CCACHE_COMPRESS=1

# Wine
export WINEPREFIX=$HOME/.wine
export WINEARCH=win64

# Java
if hash archlinux-java 2>/dev/null; then
	JAVA_HOME="/usr/lib/jvm/$(archlinux-java get)/"
else
	JAVA_HOME="/usr/lib/jvm/default/"
fi
export JAVA_HOME

# Android
export ANDROID_HOME=/opt/android-sdk

# jBOSS
export JBOSS_HOME=/opt/wildfly

# set $USER variable
if [ -z ${USER+x} ]; then
	export USER
	USER="$(id -u -n)"
fi

# ===============================
#    NON INTERACTIVE CONFIGS
# ===============================

# GPG
GPG_TTY=$(tty)
export GPG_TTY

if hash gpgconf 2> /dev/null; then
	if ! pgrep -u "$USER" gpg-agent > /dev/null; then
		gpgconf --launch gpg-agent
	fi

	if ! pgrep -u "$USER" dirmngr > /dev/null; then
		gpgconf --launch dirmngr
	fi
fi

if [ -z ${SSH_AUTH_SOCK+x} ]; then
	GNUPG_AGENT_ENABLED=0

	# GPG Agent with SSH support
	if pgrep -u "$USER" gpg-agent > /dev/null; then
		GNUPG_AGENT_ENABLED=1
		unset SSH_AGENT_PID
		if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
			SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
			export SSH_AUTH_SOCK
		fi
	fi

	# Fallback to SSH Agent
	if [ $GNUPG_AGENT_ENABLED == "0" ]; then
		# SSH Agent
		if ! pgrep -u "$USER" ssh-agent > /dev/null; then
		    ssh-agent -s > "$HOME/.ssh-agent-env"
		fi

		# Load SSH Agent environment file if exists
		if [ -f "$HOME/.ssh-agent-env" ]; then
			# shellcheck disable=SC1090
			source "$HOME/.ssh-agent-env" > /dev/null
		fi
	fi


fi

# Add .local/bin/ to PATH
export PATH="$HOME/.local/bin:$PATH"

# ===============================
#        EARLY BOOTSTRAP
# ===============================

# If not running interactively, don't do anything!
[[ $- != *i* ]] && return

# set safe failures
set -euo pipefail

(( BASH_VERSINFO[0] < 4 )) && echo "Bash 4+ required." && exit 1

# wait for user input
akey_continue() { read -n 1 -s -r -p "Press any key to continue"; }
trap akey_continue EXIT

if [ "$TERM" == "xterm-kitty" ]; then
	if [ ! -f "/usr/share/terminfo/x/xterm-kitty" ]; then
		# fallback to a legacy supported terminfo
		export TERM=xterm-256color
	elif [[ -n ${SSH_CLIENT+x} || -n ${SSH_TTY+x} ]]; then
		export COLORTERM=truecolor
	fi
fi

# define set_windowtitle and ncolors as early as possible
case "$TERM" in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|linux*|tmux*)
		set_windowtitle() {
			#[[ -n ${DISPLAY+x} ]] && echo -ne "\033]0;$*\007" || :
			echo -ne "\033]0;$*\007"
		}
		# check number of colors available
		ncolors="$(tput colors)"
		;;
	*)
		set_windowtitle() {
			:
		}
		ncolors=0
		;;
	esac

# set window title for initialization
set_windowtitle ".bashrc: init"

# add newline to seperate last session line from tty
[[ "$TERM" == linux* ]] && echo || :

# ===============================
#       COLORS DEFINITION
# ===============================

if test -n "$ncolors" && test $ncolors -ge 8; then
	fg_bold="\e[1m"
	reset_fg_bold="\e[21m"

	dim_color="\e[2m"
	reset_dim_color="\e[22m"

	fg_underlined="\e[4m"
	reset_fg_underlined="\e[24m"

	blink_color="\e[5m"
	reset_blink_color="\e[25m"

	reverse_color="\e[7m"
	reset_reverse_color="\e[27m"

	hidden_color="\e[8m"
	reset_hidden_color="\e[28m"

	reset_colors="\e[0m"

	fg_default_color="\e[39m"
	fg_red="\e[31m"
	fg_green="\e[32m"
	fg_yellow="\e[33m"
	fg_cyan="\e[36m"
	fg_dark_gray="\e[90m"
	fg_light_red="\e[91m"
	fg_light_green="\e[92m"
	fg_light_magenta="\e[95m"
	fg_light_cyan="\e[96m"

	# Log levels alias
	info="$fg_cyan" # info
	warn="$fg_yellow" # yellow
	err="$fg_red" # error
else
	# dont mark log levels as unbound variables
	info='' warn='' err=''
fi

# Logger
# This function log messages
# Usage: log <LEVEL> <MESSAGE>
log_msg2() {
    echo -e " $1--> ${fg_dark_gray}$2${reset_colors}"
}

# Fatal logger
# This function log fatal messages
# Usage: fatal <MESSAGE> <EXIT_CODE>
log_fatal_msg2() {
    log_msg2 "$err" "$1"
    exit "$([ $# -eq 2 ] && echo "$2" || echo 1)"
}

# ===============================
#             STARTUP
# ===============================

# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/functions.sh"
# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/alias.sh"

# block user input
stty -echo

# .bashrc paths
BASHRC_CHECKSUM="$(cksum "$HOME/"{.bashrc,.oh-luis-bash/*})"
BASHRC_CHECKSUM_FILE="$HOME/.bashrc.check"

NON_INTERACTIVE_INSTALL="0"

install_archpkg_pacman() {
	sudo pacman -S "$1" --noconfirm --needed
}

install_archpkg_yay() {
	yay -S "$1" --noconfirm --needed
}

install_archpkg() {
	case $1 in
		aur ) install_archpkg_aur "$2";;
		pacman ) install_archpkg_pacman "$2";;
	esac
}

install_archpkg_prompt() {
	if [ "$NON_INTERACTIVE_INSTALL" == "1" ]; then
		install_archpkg "$1" "$2"
	elif [ "$NON_INTERACTIVE_INSTALL" == "0" ]; then
		while true; do
		    read -rp "Do you wish to install '$2' program? [ynaq]" yn
		    echo
		    case $yn in
		        [Yy]* ) install_archpkg "$1" "$2"; break;;
		        [Aa]* ) NON_INTERACTIVE_INSTALL="1"; install_archpkg "$1" "$2"; break;;
		        [Qq]* ) NON_INTERACTIVE_INSTALL="-1"; break;;
		        [Nn]* ) break;;
		        * ) echo "Please answer yes, no, all or Q/q for never.";;
		    esac
		done
	else
		echo "Ignoring installation of '$2'"
	fi
}

# if this file changed, run checks
if [[ ! -f "$BASHRC_CHECKSUM_FILE" || ! "$BASHRC_CHECKSUM" == "$(cat "$BASHRC_CHECKSUM_FILE")" ]]; then
	NEW_BASHRC=1

	# set window title for new file routine
	set_windowtitle ".bashrc: check new file"

	echo -e "New .bashrc loaded!\n"

	if ! hash pygmentize 2> /dev/null; then
		log_msg2 "$warn" "Package 'pygmentize' is not installed"
		install_archpkg_prompt 'pacman' 'pygmentize'
	fi

	# check if bash-completion is installed
	if [ ! -d /usr/share/bash-completion ]; then
		log_msg2 "$warn" "Package 'bash-completion' is not installed"
		install_archpkg_prompt 'pacman' 'bash-completion'
	fi

	# check if git is installed
	if ! hash git 2> /dev/null; then
		log_msg2 "$warn" "Package 'git' is not installed"
		install_archpkg_prompt 'pacman' 'git'
	fi

	# check if ssh is installed
	if ! hash ssh 2> /dev/null; then
		log_msg2 "$warn" "Package 'openssh' is not installed"
		install_archpkg_prompt 'pacman' 'openssh'
	fi

	# check if thefuck is installed
	if ! hash thefuck 2> /dev/null; then
		log_msg2 "$warn" "Package 'thefuck' is not installed"
		install_archpkg_prompt 'pacman' 'thefuck'
	fi

	if ! hash micro 2> /dev/null; then
		log_msg2 "$warn" "Recommended to install micro"
	fi

	if ! hash lsd 2> /dev/null; then
		log_msg2 "$warn" "Recommended to install lsd"
		install_archpkg_prompt 'pacman' 'lsd'
	fi

	if ! hash figlet 2> /dev/null; then
		log_msg2 "$warn" "Package 'figlet' is not installed"
		install_archpkg_prompt 'pacman' 'figlet'
	fi

	if ! hash fortune 2> /dev/null; then
		log_msg2 "$warn" "Package 'fortune-mod' is not installed"
		install_archpkg_prompt 'pacman' 'fortune-mod'
	fi

	if hash nano 2> /dev/null && [ ! -f ~/.nanorc ]; then
		log_msg2 "$info" "Creating a .nanorc file to support colors"
		touch "$HOME/.nanorc"

		# adding every supported language at the
		find /usr/share/nano/ -iname "*.nanorc" -exec echo include {} \; >> ~/.nanorc
	fi

	log_msg2 "$info" "Calculating checksum for .bashrc"
	echo "$BASHRC_CHECKSUM" > "$BASHRC_CHECKSUM_FILE"

	# add a final newline to the log
	echo


	# set window title to warn user
	set_windowtitle ".bashrc: waiting for user input"

	# wait for user input
	akey_continue
	# clear entire screen
	printf "\033c"
fi

# Bash completion
# shellcheck disable=SC1091
[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

# pkgfile hook
if [ -f "/usr/share/doc/pkgfile/command-not-found.bash" ]; then
	# shellcheck disable=SC1091
	source /usr/share/doc/pkgfile/command-not-found.bash
fi

# Bash options
# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/shopt.sh"

# Input binds
# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/binds.sh"

# ===============================
#         CONFIGURATIONS
# ===============================

if test -n "$ncolors" && test $ncolors -ge 8; then
	# add termcap for less when colors are available
	export LESS=-R
	export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
	export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
	export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
	export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
	export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
	export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
	export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

	if hash dircolors 2> /dev/null; then
		eval "$(dircolors -b ~/.oh-luis-bash/.dircolors)"
	fi
fi

if [ -n "${COLORTERM+x}" ] && [ "$COLORTERM" == "truecolor" ] && hash micro 2> /dev/null; then
	MICRO_TRUECOLOR=1
	export MICRO_TRUECOLOR
fi

if hash lsd 2> /dev/null; then
	alias ls="lsd"
fi

# Editor configurations
if hash nvim 2> /dev/null; then
	EDITOR='nvim'
	VISUAL='nvim'
# fallback to micro
elif hash micro 2> /dev/null && test -n "$ncolors" && test $ncolors -ge 8; then
	EDITOR='micro'
	VISUAL='micro'
# fallback to nano text editor
elif hash nano 2> /dev/null; then
	EDITOR='nano'
	VISUAL='nano'
# fallback to vim
elif hash vim 2> /dev/null; then
	EDITOR='vim'
	VISUAL='vim'
# fallback to vi if none found
else
	if ! hash vi 2> /dev/null; then
		log_msg2 "$warn" "Falling to 'vi' as default editor but not installed!"
	fi

	EDITOR='vi'
	VISUAL='vi'
fi

export EDITOR
export VISUAL

if hash thefuck 2> /dev/null; then
	eval "$(thefuck --alias)"
fi

GPG_TTY="$(tty)"
export GPG_TTY

# Kitty
if [ "$TERM" == "xterm-kitty" ] && hash kitty 2> /dev/null; then
	# shellcheck disable=SC1090
	source <(kitty + complete setup bash)

	alias ssh='kitty kitten ssh'
fi


# ===============================
#          DYNAMIC ALIAS
# ===============================

# Improved commands
if test -n "$ncolors" && test $ncolors -ge 8; then
	alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
	if ! hash lsd 2> /dev/null; then
		alias ls='ls --color=tty'
	fi
	alias ip='ip -color=auto'
	alias dmesg='dmesg --color=always'
else
	alias grep='grep --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
fi

# ===============================
#            COMMANDS
# ===============================

# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/goto-command.sh"
# shellcheck disable=SC1090
source "$HOME/.oh-luis-bash/with-command.sh"

# ===============================
#              PROMPT
# ===============================

rprompt_git()
{
	local abrev_head dirty_status ret="";

	# guess abrev head name
	abrev_head="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

	if [ "$abrev_head" == "HEAD" ]; then
		# on detached branch, give short hash instead
		abrev_head="$(git rev-parse --short HEAD 2>/dev/null)"

		# maybe no detached branch and no history
		# shellcheck disable=SC2181
		if [ $? -gt 0 ]; then
			abrev_head="$(git branch --show-current 2>/dev/null)"
		fi
	fi

	# check if branch was modified
	dirty_status="$([[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]] && echo "*")"

	# start branch identifier and dirty status scope
	ret+="${fg_bold}${fg_default_color}["
	ret+="${fg_light_green}${abrev_head}${dirty_status}"
	# close scope and reset colors
	ret+="${fg_default_color}]${reset_colors}"
	echo -en "$ret"
}

# Print the right prompt
# Please use this to print:
#  printf "%*s" $COLUMNS "ATUM"
rightprompt()
{
	local printable c_printable

	if git rev-parse --git-dir &> /dev/null; then
		printable="$(rprompt_git)"
	fi

	c_printable="$(echo -e "$printable" | sed "s/$(echo -e "\e")[^m]*m//g")"

	if [ "$printable" != "" ]; then
		printf "%*s" $((COLUMNS + ${#printable} - ${#c_printable} )) "$printable"
	fi
}

prompt_exitstatus()
{
	# save exit code to use later
    PROMPT_EXITSTATUS="${?}"

    if [[ ${PROMPT_EXITSTATUS} == "0" ]]
    then
        PROMPT_EXITSTATUS=
    else
        PROMPT_EXITSTATUS+=" "
    fi
}

function prompt_settitle () {
	# return on tab completion
	[[ -n "${COMP_LINE:-}" ]] && return || :

	# return on calling PROMPT_COMMAND
	[ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return || :

	# old way to fetch the command
	# local title="${BASH_COMMAND//[^[:print:]]/}"

	local title title_cmd using_root tmp_var

	using_root=0

	title_cmd="$(
		export LC_ALL=C
		HISTTIMEFORMAT='' builtin history 1 | sed '1 s/^ *[0-9][0-9]*[* ] //'
	)"

	if [[ "$title_cmd" == *=* ]]; then
		title_cmd="$(echo "$title_cmd" | awk '{ print substr($0, 1, 20) }')"
	else
		# get first executable name
		title_cmd="$(echo "$title_cmd" | sed -e 's/^[[:space:]]*//')"
		[[ "$title_cmd" == sudo* ]] && using_root=1 || using_root=0
		tmp_var="$(echo "$title_cmd" | sed 's/\\ /\n/' | cut -d ' ' -f $((1 + using_root)) | tr '\n' ' ' | sed -e 's/[[:space:]]*$//')"
		if [[ "$tmp_var" =~ ^-.* ]]; then
			using_root=0
			title_cmd="$(echo "$title_cmd" | awk '{ print substr($0, 1, 20) }')"
		else
			title_cmd="$tmp_var"
		fi
	fi

	if [ "${#title_cmd}" -eq 20 ]; then
		title_cmd+="..."
	fi

	title=""

	if [[ "$PROMPT_TITLE" -gt 0 ]]; then
		if [ -n "${PROMPT_PRE_TITLE+x}" ]; then
			title+="$PROMPT_PRE_TITLE"
		fi
		title+="($title_cmd) "
		[ "$using_root" -gt 0 ] && title+="root" || title+="$USER"
		title+="@$HOSTNAME:"
		[ "$using_root" -gt 0 ] && title+="$(HOME='/root' spwd)" || title+="$PROMPT_SPWD"

		set_windowtitle "$title"
	fi
}

function prompt_timer_now {
    date +%s%N
}

function prompt_timer_start {
    prompt_timer_start_var=${prompt_timer_start_var:-$(prompt_timer_now)}
}

function prompt_timer_stop {
    local delta_us="$((($(prompt_timer_now) - prompt_timer_start_var) / 1000))"
    local us=$((delta_us % 1000))
    local ms=$(((delta_us / 1000) % 1000))
    local s=$(((delta_us / 1000000) % 60))
    local m=$(((delta_us / 60000000) % 60))
    local h=$((delta_us / 3600000000))

    if ((h > 0)); then PROMPT_TIMER=${h}h${m}m
    elif ((m > 0)); then PROMPT_TIMER=${m}m${s}s
    elif ((s >= 10)); then PROMPT_TIMER=${s}.$((ms / 100))s
    elif ((s > 0)); then PROMPT_TIMER=${s}.$(printf %03d $ms)s
    elif ((ms >= 100)); then PROMPT_TIMER=${ms}ms
    elif ((ms > 0)); then PROMPT_TIMER=${ms}.$((us / 100))ms
    else PROMPT_TIMER=${us}us
    fi
    unset prompt_timer_start_var
}

function prompt_debug_cb () {
	prompt_settitle
	prompt_timer_start
}

prompt_command () {
	prompt_exitstatus
	prompt_timer_stop
	PROMPT_SPWD="$(spwd)"
}

if [[ "$TERM" != linux* && "$TERM" != screen* ]]; then
	PROMPT_TITLE=0
	export PROMPT_TITLE
	trap 'prompt_debug_cb' DEBUG
fi

PROMPT_PRE_TITLE=""
PROMPT_TIMER=""

case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|linux*|tmux*)
	PROMPT_COMMAND="prompt_command"
	export PROMPT_COMMAND

	# right-side definition
	PS1="\\[\$(tput sc; rightprompt; tput rc)\\]"

	# left-side definition

	# set window title
	#shellcheck disable=SC2025
	PS1+='\[\e]2;'
	if [[ -n ${SSH_CLIENT+x} || -n ${SSH_TTY+x} ]]; then
		PROMPT_PRE_TITLE+='[ssh] '
	fi
	PS1+="$PROMPT_PRE_TITLE"
	PS1+='\u@\h:$PROMPT_SPWD\a\]'

	# start bold
	PS1+="\\[${fg_bold}\\]"

	# check for root user
	if [ "$EUID" -eq 0 ]; then
		PS1+="\\[${fg_red}\\]"
	else
		PS1+="\\[${fg_light_cyan}\\]"
	fi
	# location info
	PS1+="\\u@\\h \\[${fg_light_green}\\]\$PROMPT_SPWD "
	# exit status handeling
	PS1+="\\[${fg_light_red}\\]\$PROMPT_EXITSTATUS"

	PS1+="\\[${fg_dark_gray}\\]\$PROMPT_TIMER \\[${reset_colors}\\]"

	# final arrow
	PS1+="\\[${fg_light_magenta}\\]►\\[${reset_colors}\\] "

	export PS1
	export PS2="\\[${fg_light_magenta}\\]►\\[$reset_colors\\] "
	#\\[\$(tput sc; echo -en "${fg_light_red}↵$reset_colors"; tput rc)\\]
	;;
*)
	# Default prompt PS1
	PS1='[\u@\h \W]\$ '
	export PS1
	;;
esac

if [[ "$TERM" == screen* ]]; then
	export PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
elif [[ "$TERM" == linux* ]]; then
	# set terminal cursor on tty
	export PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'tput cnorm'
fi


# ===============================
#           GREETINGS
# ===============================

# greetings only on normal users
if [ "$EUID" -ne 0 ]; then

NUMBER_OF_SESSIONS="$(who | wc -l)"
NUMOF_ONLINE_NETWORKS=0
# shellcheck disable=SC2010
for interface in $(ls /sys/class/net/ | grep -v lo); do
  if [[ "$(cat "/sys/class/net/$interface/carrier" 2>/dev/null)" == 1 ]]; then
  	NUMOF_ONLINE_NETWORKS=$((NUMOF_ONLINE_NETWORKS+1))
  fi
done

echo " Welcome,"

figlets_arr=('standard' 'big' 'slant' 'small' 'banner' 'mini' 'smslant' 'script' 'smscript' 'shadow' 'smshadow')
GREETINGS_HEADER="$( if hash figlet 2>/dev/null; then
	figlet -f "${figlets_arr[$((RANDOM % ${#figlets_arr[@]}))]}" lsferreira
else
	# lsferreira header
	cat << EOF
 ┬  ┌─┐┌─┐┌─┐┬─┐┬─┐┌─┐┬┬─┐┌─┐
 │  └─┐├┤ ├┤ ├┬┘├┬┘├┤ │├┬┘├─┤
 ┴─┘└─┘└  └─┘┴└─┴└─└─┘┴┴└─┴ ┴
EOF
fi )"

# pride month with lolcat
if hash lolcat 2>/dev/null && [ "$(date +%m)" == "06" ]; then
	echo -e "$GREETINGS_HEADER\n\n It's pride month!\n" | lolcat
else
	echo -e "$GREETINGS_HEADER"
fi

# last logged session
{ [[ "$TERM" != linux* ]] || [[ "$TERM" == linux* && -n ${NEW_BASHRC+x} ]]; } \
	&& echo -e " Last Session: $(last -1 -R "$USER" -n 1 | head -1 |cut -c 23-38)" \
	|| :

# print number of active sessions if greater than 1
if [ "$NUMBER_OF_SESSIONS" -gt 1 ]; then
	echo -e " There's currently $NUMBER_OF_SESSIONS active sessions."
fi

# reminder for no network connection
if [ "$NUMOF_ONLINE_NETWORKS" -eq 0 ]; then
	echo -e " You're not connected to any network."
fi

# Write random quote
if hash fortune 2> /dev/null; then
	printf '\n%s\n' "$(fortune)"
fi

fi # [ "$EUID" -ne 0 ]

# ===============================
#        FINAL BOOTSTRAP
# ===============================

# reenable input
stty echo

# reenable bash failures
set +euo pipefail

# untrap exit
trap - EXIT

# trap hide cursor on tty exit
[[ "$TERM" == linux* ]] && trap 'tput civis' EXIT || :

# set title
PROMPT_TITLE=1
export PROMPT_TITLE
