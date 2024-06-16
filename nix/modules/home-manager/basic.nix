{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  home.stateVersion = mkGenericDefault trivial.release;
}
