{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  # Enable CUPS to print documents.
  services.printing.enable = true;
  programs.system-config-printer.enable = true;

  # Enable Avahi service
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
}
