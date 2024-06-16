{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  environment.systemPackages = with pkgs;
    [
      busybox
      binutils
      llvmPackages.bintools
      less
      tree
      wget
      usbutils
      pciutils
      neovim
      pkg-config

      gcc
      llvm
      clang

      gnumake
      cmake
    ];
}
