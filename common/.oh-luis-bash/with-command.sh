#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

# ===============================
#    WITH COMPLETION COMMAND
# ===============================

_with_usage()
{
  echo -e "Usage: with <prefix>"
}

_with_help()
{
  _with_usage

  echo -e "\n  -h, --help   : Display command help"
}

with()
{
	#add options here, such as -h, -v
	declare -a prefix
	prefix=( "$@" )

	case ${prefix[*]} in
	  "" )
	  	echo "Missing arguments."
	    _with_usage
	    ;;
	  "-h"|"--help")
	    _with_help
	    ;;
	  -*)
	    echo "Unrecognised option: ${prefix[*]}"
	    _with_help
	    ;;
	esac

	pmpt=${prefix[*]}
}
