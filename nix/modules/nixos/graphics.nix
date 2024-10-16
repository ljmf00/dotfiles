{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  boot.plymouth.enable = true;

  # required for gnome3 pinentry package on non-gnome
  services.dbus.packages = [ pkgs.gcr ];

  boot.kernelParams = [ "splash" "quiet" ];
}
