{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./.

    ./gdm/system.nix
  ];
}
