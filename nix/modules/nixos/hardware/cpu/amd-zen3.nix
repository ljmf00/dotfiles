{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  imports = [
    ./amd-pstate.nix
    ./amd-kvm.nix
  ];

  nix.settings.system-features = [ "gccarch-znver3" "gccarch-x86-64-v2" "gccarch-x86-64-v3" ];

  # nixpkgs.localSystem = {
  #   gcc.arch = "znver3";
  #   gcc.tune = "znver3";
  # };
}
