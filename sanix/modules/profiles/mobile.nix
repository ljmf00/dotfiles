{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./pc.nix
  ];

  sanix.hardware = [ "wifi" "bluetooth" "fingerprint" ];
}