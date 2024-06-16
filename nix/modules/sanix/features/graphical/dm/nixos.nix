{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./.

    ./gdm/nixos.nix
  ];
}
