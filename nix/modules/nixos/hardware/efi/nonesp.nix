{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  imports = [
    ./.
  ];

  boot.loader.efi.efiSysMountPoint = "/boot";

  fileSystems."/boot" = mkGenericDefault
    {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
}
