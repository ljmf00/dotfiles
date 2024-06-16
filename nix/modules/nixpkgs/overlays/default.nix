{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./musl.nix
    ./wayland.nix
    ./nur.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
        OVMF = prev.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        };
    })
  ];
}
