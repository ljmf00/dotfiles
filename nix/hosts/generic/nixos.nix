{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  imports = [
    ./../../profiles/system/minimal.nix
  ];
}
