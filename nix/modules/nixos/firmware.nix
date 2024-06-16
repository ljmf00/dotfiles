{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  hardware.enableRedistributableFirmware
    = mkGenericDefault true;

  # enable fwupd firmware update service
  services.fwupd.enable = true;
}
