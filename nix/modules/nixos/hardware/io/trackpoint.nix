{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
    hardware.trackpoint.enable = mkGenericDefault true;
    hardware.trackpoint.emulateWheel = mkGenericDefault config.hardware.trackpoint.enable;
}
