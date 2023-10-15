{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  boot.initrd.availableKernelModules = [ "cryptd" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];

  environment.systemPackages = with pkgs;
    [
      ccrypt
      cryptsetup
    ];

  boot.initrd.luks.devices = {
      luks = {
        device = "/dev/disk/by-label/NIXCRYPT";
        allowDiscards = true;
	      preLVM = true;
      };
  };
}
