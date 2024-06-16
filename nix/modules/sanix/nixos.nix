{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./.

    ./base/nixos.nix
    ./hardware/nixos.nix
    ./features/nixos.nix
  ];
}
