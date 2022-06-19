#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck disable=SC2015

# ===============================
#              BINDS
# ===============================

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
