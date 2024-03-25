{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./.

    ./hardware/system.nix
    ./features/system.nix
  ];
}