{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  home.shellAliases = {
    # Git
    "g"    = "git";
    "gst"  = "git status";
    "glo"  = "git log --oneline --decorate";
    "glog" = "git log --oneline --decorate --graph --all";

    # TTY/PTY compatibility
    "ssh"  = "TERM=xterm-256color ssh";
    "mosh" = "TERM=xterm-256color mosh";
    "tmux" = "TERM=xterm-256color tmux";

    # Misc
    "bashconfig" = "$EDITOR ~/.bashrc";
    "please" = "sudo";
  };

  programs.bash = {
    enable               = true;
    enableCompletion     = true;
    enableVteIntegration = true;

    historySize = 50000;

    historyControl = [
      "ignoredups"
      "ignorespace"
    ];

    historyIgnore = [
      "ls"
      "cd"
      "exit"
    ];

    sessionVariables = {
      "IGNOREEOF" = 10;
      "PROMPT_DIRTRIM" = 2;
      "LD_LIBRARY_PATH" = "$LD_LIBRARY_PATH:/run/opengl-driver/lib:/run/opengl-driver-32/lib:/usr/lib:/usr/lib32";
      "XDG_DATA_DIRS" = "$XDG_DATA_DIRS:/run/opengl-driver/share:/run/opengl-driver-32/share:/usr/share";
    };

    shellOptions = [
      "checkwinsize"
      "histappend"
      "autocd"
      "dirspell"
      "cdspell"
      "globstar"
      "nocaseglob"
    ];

    bashrcExtra = ''
      function _append_path()
      {
          if [[ ":$PATH:" == *":$1:"* ]]; then
              echo "$PATH"
          else
              echo "$1:$PATH"
          fi
      }

      # set $USER variable
      if [ -z "''${USER+x}" ] || [ "$USER" == "" ]; then
          USER="$(id -u -n)"
          export USER
      fi

      # set $HOME variable
      if [ -z "''${HOME+x}" ] || [ "$HOME" == "" ]; then
          HOME="$(cd ~ && echo "$PWD")"
          export HOME
      fi

      if [ -d "$HOME/.local/bin" ]; then
        PATH="$(_append_path "$HOME/.local/bin")"
        export PATH
      fi
    '';

    initExtra = ''
      # set $TERM variable if not set
      if [ -z ''${TERM+x} ]; then
          export TERM=xterm
      fi

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

      # GPG
      GPG_TTY="$(tty)"
      export GPG_TTY

      if hash gpgconf 2> /dev/null; then
        if ! pgrep -u "$USER" gpg-agent >/dev/null 2>&1; then
          gpgconf --launch gpg-agent
        fi

        if ! pgrep -u "$USER" dirmngr >/dev/null 2>&1; then
          gpgconf --launch dirmngr
        fi

          if [[ -z ''${SSH_AUTH_SOCK+x} ]] && [[ -f "$HOME/.gnupg/sshcontrol" ]]; then
              export SSH_AGENT_PID=
              SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
              export SSH_AUTH_SOCK
          fi
      fi

      # SSH
      if [[ -z ''${SSH_AUTH_SOCK+x} ]]; then
          if ! pgrep -u "$USER" ssh-agent > /dev/null; then
              ssh-agent -t 15m > "$XDG_RUNTIME_DIR/ssh-agent.env"
          fi

          if [ -f "$XDG_RUNTIME_DIR/ssh-agent.env" ]; then
              source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
          else
              eval "$(ssh-agent -t 15m | tee "$XDG_RUNTIME_DIR/ssh-agent.env")"
          fi
      fi

      # External completion integrations

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
    '';
  };

  programs.starship.enable = true;
  programs.thefuck.enable = true;
  programs.dircolors.enable = true;
  programs.fzf.enable = true;

  programs.lsd = {
    enable = true;
    enableAliases = true;

    settings = {
      date = "relative";
      ignore-globs = [
        ".git"
        ".hg"
      ];
    };
  };

  home.packages = with pkgs;
  [
    mosh # mobile shell (on top of tmux + ssh)
  ];
}
