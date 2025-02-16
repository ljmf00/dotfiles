{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./graphical.nix

    ./../../modules/nixos/packages/essentials.nix

    ./../../modules/nixos/monitoring.nix
    ./../../modules/nixos/proxy.nix
    ./../../modules/nixos/sync.nix
    # ./../../modules/nixos/android.nix
    ./../../modules/nixos/location.nix
    ./../../modules/nixos/virtualisation.nix

    ./../../modules/nixos/crossplatform.nix
  ];
}
