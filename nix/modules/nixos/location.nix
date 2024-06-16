{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  location.provider = "geoclue2";
  services.geoclue2.enable = true;
}
