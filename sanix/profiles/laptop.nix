{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./mobile.nix
  ];

  sanix.hardware = [ "backlight" ];
}