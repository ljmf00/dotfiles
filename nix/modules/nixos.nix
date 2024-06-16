{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./sanix/nixos.nix
  ];
}
