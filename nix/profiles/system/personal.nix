{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./graphical.nix
    
    ./../../modules/system/monitoring.nix
    ./../../modules/system/proxy.nix
    ./../../modules/system/sync.nix
    ./../../modules/system/android.nix
    ./../../modules/system/location.nix
    
    ./../../modules/system/crossplatform.nix
  ];
}
