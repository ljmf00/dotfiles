{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  imports = [
    ./../../nix/profiles/system/minimal.nix
  ];
}