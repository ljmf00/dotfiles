{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
    boot.kernelModules = [ "msr" ];
    nixpkgs.hostPlatform = mkGenericDefault "x86_64-linux";
}