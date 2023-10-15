{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  time.timeZone = mkGenericDefault "Europe/Lisbon";

  i18n.defaultLocale = mkGenericDefault "en_US.UTF-8";

  services.xserver.layout = mkGenericDefault "us";
  services.xserver.xkbOptions = mkGenericDefault "eurosign:e,caps:escape";
}