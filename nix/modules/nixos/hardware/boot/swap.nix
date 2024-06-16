{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  # enable zram
  zramSwap.enable = true;

  # hibernate to swap device
  boot.resumeDevice = mkGenericDefault "/dev/disk/by-label/NIXSWAP";

  swapDevices = mkGenericDefault
    [ { device = "/dev/disk/by-label/NIXSWAP"; } ];
}
