{ config, lib, pkgs, inputs, ...}:
  with lib;
{
  # "hardware-x86_64" "hardware-x86_64-kvm"
  # "hardware-x86_64-amd"
  # "hardware-emulate-arm" "hardware-emulate-riscv" "hardware-emulate-wasm"

  # hardware-bluetooth
  # hardware-ssd hardware-ssd-nvme
  # hardware-usb

  # documentation
  sanix.hardware = [
    "cpu-x86_64-amd-zen3" "gpu-amd" "audio" "usb" "wifi" "ethernet" "bluetooth" "input" "virtualisation"
  ];

  sanix.features = [
    "unfree" "hardening"
    "documentation" "fonts"
    "virtualisation"

    "graphical-gnome"
  ];
}
