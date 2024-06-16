{ config, lib, pkgs, inputs, stablePkgs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  # set system state version
  system.stateVersion = mkGenericDefault trivial.release;

  # use tmpfs mount for temporary folder
  boot.tmp.useTmpfs = mkGenericDefault true;

  environment.systemPackages = with stablePkgs;
    [
        # the most core utilities
        pkgs.uutils-coreutils-noprefix

        # basic lightweight utility box
        busybox

        # useful binary utility
        binutils

        # extra useful commands
        less
        tree
        curl
        wget

        # a stable compiler for the rescue
        gcc
    ];
}
