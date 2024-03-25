{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./permanent-machine.nix
    ./pc.nix
  ];
}