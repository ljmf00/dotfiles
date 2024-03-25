{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./ata/system.nix
    ./audio/system.nix
  ];
}