{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./minimal.nix
    ./graphics.nix
    ./dev.nix

    ./../../modules/home/packages/media.nix
    ./../../modules/home/packages/security.nix
    ./../../modules/home/packages/dev.nix
  ];
}
