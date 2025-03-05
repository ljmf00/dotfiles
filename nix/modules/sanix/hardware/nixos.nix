{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./ata/nixos.nix
    ./audio/nixos.nix
    ./bluetooth/nixos.nix
    ./input/nixos.nix
  ];
}
