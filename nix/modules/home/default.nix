{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  home.stateVersion = mkGenericDefault trivial.release;

  nix.channels = {
    nixpkgs = inputs.nixpkgs;
    nixpkgs-stable = inputs.nixpkgs-stable;
    nixpkgs-staging-next = inputs.nixpkgs-staging-next;
  };
}
