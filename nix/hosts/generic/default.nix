{ config, lib, pkgs, inputs, ...}:
  with lib;
{
  sanix.hardware = [
    "gpu-amd" "audio" "usb" "wifi" "ethernet" "bluetooth" "input" "virtualisation"
  ];

  sanix.features = [
    "unfree" "hardening"
    "documentation" "fonts"
    "virtualisation"

    "graphical-gnome"
  ];
}
