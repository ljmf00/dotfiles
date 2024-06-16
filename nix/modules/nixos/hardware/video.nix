{ lib, config, pkgs, ... }:
let
  # This option is removed from NixOS 23.05 and up
  nixosVersion = lib.versions.majorMinor lib.version;
in
{
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  environment.systemPackages = with pkgs; [ v4l-utils ];
}
