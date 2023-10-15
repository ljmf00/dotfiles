{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../modules/system/basic.nix
    ./../../modules/system/nix.nix
    ./../../modules/system/boot.nix

    ./../../modules/system/locale.nix
    ./../../modules/system/fonts.nix
    ./../../modules/system/users.nix

    ./../../modules/system/firmware.nix
    ./../../modules/system/security.nix
    ./../../modules/system/network.nix
    ./../../modules/system/power.nix
    
    ./../../modules/system/rescue.nix
    ./../../modules/system/storage.nix
  ];
}
