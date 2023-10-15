{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./graphical/system.nix
  ];
}