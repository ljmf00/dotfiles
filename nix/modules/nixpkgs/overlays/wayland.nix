{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  nixpkgs.overlays = [
    inputs.nixpkgs-wayland.overlay
  ];
}
