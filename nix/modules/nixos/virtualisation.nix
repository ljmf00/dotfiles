{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  virtualisation.docker.enable = true;
}
