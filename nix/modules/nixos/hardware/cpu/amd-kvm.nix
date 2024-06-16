{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  imports = [
    ./amd.nix
    ./kvm.nix
  ];

  boot.kernelModules = [ "kvm-amd" ];
}
