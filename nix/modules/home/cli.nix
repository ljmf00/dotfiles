{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  programs.less.enable = true;
  programs.jq.enable = true;
  programs.readline.enable = true;
  programs.btop.enable = true;
  programs.htop.enable = true;
  programs.tmate.enable = true;
  programs.matplotlib.enable = true;

  home.packages = with pkgs;
    [
      zip
      unzip
      screen

      ripgrep

      openssh # remote shell
    ];

  programs.aria2.enable = true;
  programs.pyenv.enable = true;
  programs.rbenv.enable = true;
}
