{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  imports = [
    ./x86_64.nix
  ];

  hardware.cpu.amd.updateMicrocode =
    mkGenericDefault config.hardware.enableRedistributableFirmware;
}
