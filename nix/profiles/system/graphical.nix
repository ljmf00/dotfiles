{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./minimal.nix

    ./../../modules/system/graphics.nix
  ];
}
