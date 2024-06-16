{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../modules/home/gui.nix
    ./../../modules/home/fonts.nix
    ./../../modules/home/hyprland
  ];
}
