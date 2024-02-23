{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./permanent-machine.nix
  ];

  sanix.hardware = [ "ipmi" "scsi" ];
}