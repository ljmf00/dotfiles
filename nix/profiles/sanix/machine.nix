{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  sanix.hardware = [
    "ethernet" "usb" "pci" "ssd" "ata" "authkey" "smartcard"
  ];
}
