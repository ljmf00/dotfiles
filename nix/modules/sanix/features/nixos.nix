{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./graphical/nixos.nix
    ./documentation/nixos.nix
  ];
}
