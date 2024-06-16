{ config, lib, pkgs, inputs, ... }:
  with lib;
{
    boot.initrd.systemd.enable = true;
    systemd.enableEmergencyMode = true;

    boot.loader.grub.memtest86.enable = true;
    boot.loader.systemd-boot.memtest86.enable = true;

    environment.systemPackages = with pkgs;
    [
      testdisk
      ddrescue
      smartmontools
    ];
}
