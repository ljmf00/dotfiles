{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  imports = [
    ./../../profiles/nixos/minimal.nix
  ];
}
