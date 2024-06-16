{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./pc.nix

    ./../../modules/nixos/hardware/io/fingerprint.nix
    ./../../modules/nixos/hardware/io/trackpoint.nix
  ];
}
