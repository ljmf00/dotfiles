{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  networking.networkmanager.enable = true;

  # Wireless settings
  networking.wireless = {
    enable = true;
    iwd.enable = true;

    userControlled.enable = true;
  };
  systemd.services.wpa_supplicant.wantedBy = mkForce [];

  # needed for zfs
  networking.hostId = mkDefault "8425e349";

  networking.firewall = {
    enable = true;

    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
    allowPing = false;
  };
}
