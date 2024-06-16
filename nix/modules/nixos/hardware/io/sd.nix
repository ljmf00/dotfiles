{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
    boot.initrd.availableKernelModules = [ "sd_mod" "sdhci_pci" ];
}
