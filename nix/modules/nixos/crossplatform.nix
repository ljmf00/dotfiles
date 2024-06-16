{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  boot.binfmt.emulatedSystems = [
    "wasm32-wasi"
    "wasm64-wasi"

    "armv7l-linux"
    "aarch64-linux"

    "riscv32-linux"
    "riscv64-linux"
  ];
}
