{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  nixpkgs.overlays = [
    (final: prev: {
      # inherit (prev.pkgsMusl) uutils-coreutils-noprefix;
    })
  ];
}
