{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  hardware.enableAllFirmware
    = mkGenericDefault config.hardware.enableRedistributableFirmware;
}
