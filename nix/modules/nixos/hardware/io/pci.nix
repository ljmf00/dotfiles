{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  environment.systemPackages = with pkgs;
    [
      pciutils
    ];
}
