{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./machine.nix
  ];

  sanix.hardware = [ "audio" "input" "printer" "scanner" ];
}