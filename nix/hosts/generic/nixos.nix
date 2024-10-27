{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  imports = [
    ./../../modules/nixos/hardware/efi/nonesp.nix
    ./../../modules/nixos/hardware/boot/btrfs.nix

    ./../../profiles/nixos/minimal.nix
  ];
}
