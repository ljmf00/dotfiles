{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../nix/profiles/home/core.nix
    ./../../nix/profiles/home/dev.nix
    ./../../nix/profiles/home/graphics.nix
  ];
}
