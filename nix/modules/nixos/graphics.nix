{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  boot.plymouth.enable = true;

  boot.kernelParams = [ "splash" "quiet" ];
}
