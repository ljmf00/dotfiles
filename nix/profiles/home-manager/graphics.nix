{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../modules/home-manager/gui.nix
    ./../../modules/home-manager/fonts.nix
  ];
}
