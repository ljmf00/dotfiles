{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  home.username = "luis";
  home.homeDirectory = "/home/luis";

  home.packages = [ ];
  home.file = { };
  home.sessionVariables = { };

  programs.home-manager.enable = true;
  programs.bash.enable = true;
  programs.starship.enable = true;
  programs.neovim.enable = true;
}
