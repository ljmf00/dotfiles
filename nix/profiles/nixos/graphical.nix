{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./minimal.nix

    ./../../modules/nixos/graphics.nix
  ];
}
