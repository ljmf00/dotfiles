{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
    boot.initrd.availableKernelModules = [ "nvme" ];

    environment.systemPackages = with pkgs;
    [
      nvme-cli
    ];
}
