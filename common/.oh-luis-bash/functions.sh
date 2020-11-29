#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

# ===============================
#      FUNCTION DEFINITIONS
# ===============================

task-statistics() {
	task burndown.monthly
	task ghistory
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

last-archnews() {
	# The characters "£, §" are used as metacharacters. They should not be encountered in a feed...
	# shellcheck disable=SC2001
	# shellcheck disable=SC2046
	# shellcheck disable=SC2005
	echo -e "$(echo $(curl --silent https://www.archlinux.org/feeds/news/ | sed -e ':a;N;$!ba;s/\n/ /g') | \
		sed -e 's/&amp;/\&/g
		s/&lt;\|&#60;/</g
		s/&gt;\|&#62;/>/g
		s/<\/a>/£/g
		s/href\=\"/§/g
		s/<title>/\\n\\n\\n   :: \\e[01;31m/g; s/<\/title>/\\e[00m ::\\n/g
		s/<link>/ [ \\e[01;36m/g; s/<\/link>/\\e[00m ]/g
		s/<description>/\\n\\n\\e[00;37m/g; s/<\/description>/\\e[00m\\n\\n/g
		s/<p\( [^>]*\)\?>\|<br\s*\/\?>/\n/g
		s/<b\( [^>]*\)\?>\|<strong\( [^>]*\)\?>/\\e[01;30m/g; s/<\/b>\|<\/strong>/\\e[00;37m/g
		s/<i\( [^>]*\)\?>\|<em\( [^>]*\)\?>/\\e[41;37m/g; s/<\/i>\|<\/em>/\\e[00;37m/g
		s/<u\( [^>]*\)\?>/\\e[4;37m/g; s/<\/u>/\\e[00;37m/g
		s/<code\( [^>]*\)\?>/\\e[00m/g; s/<\/code>/\\e[00;37m/g
		s/<a[^§|t]*§\([^\"]*\)\"[^>]*>\([^£]*\)[^£]*£/\\e[01;31m\2\\e[00;37m \\e[01;34m[\\e[00;37m \\e[04m\1\\e[00;37m\\e[01;34m ]\\e[00;37m/g
		s/<li\( [^>]*\)\?>/\n \\e[01;34m*\\e[00;37m /g
		s/<!\[CDATA\[\|\]\]>//g
		s/\|>\s*<//g
		s/ *<[^>]\+> */ /g
		s/[<>£§]//g')\n\n";
}

run-help() { help "$READLINE_LINE" 2>/dev/null || man "$READLINE_LINE"; }

extract () {
   if [ -f "$1" ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf "$1"    ;;
           *.tar.gz)    tar xvzf "$1"    ;;
           *.bz2)       bunzip2 "$1"     ;;
           *.rar)       unrar x "$1"     ;;
           *.gz)        gunzip "$1"      ;;
           *.tar)       tar xvf "$1"     ;;
           *.tbz2)      tar xvjf "$1"    ;;
           *.tgz)       tar xvzf "$1"    ;;
           *.zip)       unzip "$1"       ;;
           *.Z)         uncompress "$1"  ;;
           *.7z)        7z x "$1"        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
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

#   mkiso:  creates iso from current dir in the parent dir (unless defined)
mkiso () {
  if type "mkisofs" > /dev/null; then
    if [ -z ${1+x} ]; then
      local isoname=${PWD##*/}
    else
      local isoname=$1
    fi

    if [ -z ${2+x} ]; then
      local destpath=../
    else
      local destpath=$2
    fi

    if [ -z ${3+x} ]; then
      local srcpath=${PWD}
    else
      local srcpath=$3
    fi

    if [ ! -f "${destpath}${isoname}.iso" ]; then
      echo "writing ${isoname}.iso to ${destpath} from ${srcpath}"
      mkisofs -V "${isoname}" -iso-level 3 -r -o "${destpath}${isoname}.iso" "${srcpath}"
    else
      echo "${destpath}${isoname}.iso already exists"
    fi
  else
    echo "mkisofs cmd does not exist, please install cdrtools"
  fi
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

spwd() {
    cwd=$(echo "${PWD/#$HOME/\~}" | perl -F/ -ane 'print join( "/", map { $i++ < @F - 1 ?  substr $_,0,1 : $_ } @F)')
    echo -n "$cwd"
}
