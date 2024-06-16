{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./minimal.nix
    ./graphics.nix
    ./dev.nix

    ./../../modules/home-manager/packages/media.nix
    ./../../modules/home-manager/packages/security.nix
    ./../../modules/home-manager/packages/dev.nix
  ];
}
