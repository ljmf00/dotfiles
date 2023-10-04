{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../modules/system/basic.nix
    ./../../modules/system/nix.nix
    ./../../modules/system/users.nix
    ./../../modules/system/fonts.nix
    ./../../modules/system/network.nix
  ];
}
