{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  imports = [
    ./basic.nix
    ./../../modules/system/hardened.nix
  ];
}
