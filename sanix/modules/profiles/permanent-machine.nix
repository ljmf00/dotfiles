{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./machine.nix
  ];

  sanix.hardware = [ "ups" ];
}