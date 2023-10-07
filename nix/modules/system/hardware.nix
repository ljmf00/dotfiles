{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
}
