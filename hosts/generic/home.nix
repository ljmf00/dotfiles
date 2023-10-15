{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../nix/profiles/home/minimal.nix
  ];
}
