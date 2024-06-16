{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "vfat" ];

  environment.systemPackages = with pkgs;
    [
      efibootmgr
      efivar

      gptfdisk
    ];
}
