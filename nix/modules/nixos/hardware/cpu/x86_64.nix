{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
    boot.kernelModules = [ "msr" ];

    # This is the old parameter
    # nixpkgs.hostPlatform = mkGenericDefault "x86_64-linux";

    nixpkgs.localSystem = {
      system = "x86_64-linux";
    };
}
