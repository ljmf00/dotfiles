{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  config = mkIf (builtins.elem "bluetooth" config.sanix.hardware) {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };

    services.blueman.enable = true;
    environment.systemPackages = with pkgs; [ bluez-tools ];
    services.dbus.packages = with pkgs; [ blueman ];
  };
}
