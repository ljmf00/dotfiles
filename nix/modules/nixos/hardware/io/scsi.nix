{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
    boot.initrd.availableKernelModules = [
      "3w-9xxx" "3w-xxxx" "aic79xx" "aic7xxx" "arcmsr" "hpsa"
    ];
}
