{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;
  environment.systemPackages = with pkgs; [ bluez-tools ];
  services.dbus.packages = with pkgs; [ blueman ];
}