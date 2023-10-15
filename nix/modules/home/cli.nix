{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  programs.less.enable = true;
  programs.fzf.enable = true;
  programs.jq.enable = true;
  programs.readline.enable = true;
  programs.btop.enable = true;
  programs.htop.enable = true;
  programs.tmate.enable = true;

  home.packages = with pkgs;
    [
      zip
      unzip
      screen

      ripgrep

      openssh # remote shell
      mosh # mobile shell (on top of tmux + ssh)
      tmux # terminal multiplexer
    ];

  programs.aria2.enable = true;
  programs.dircolors.enable = true;

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
}
