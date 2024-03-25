{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./pc.nix

    ./../../modules/system/hardware/io/fingerprint.nix
    ./../../modules/system/hardware/io/trackpoint.nix
  ];
}
