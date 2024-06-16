{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  documentation.enable = true;

  documentation.doc.enable = true;
  documentation.info.enable = true;
  documentation.man.enable = true;
  documentation.nixos.enable = true;
}
