{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  home.packages = with pkgs;
    [
      # Generic utilities
      binutils-unwrapped-all-targets

      # Compilers and compilers related utility
      # gcc13
      # gccgo13

      llvmPackages_latest.llvm
      llvmPackages_latest.bintools-unwrapped
      llvmPackages_latest.clang-unwrapped

      ldc
      # dmd

      ccache

      # Linkers
      mold

      # Languages and languages utility
      go
      python3

      # Build utilities
      cmake
      gnumake
      ninja
    ];
}
