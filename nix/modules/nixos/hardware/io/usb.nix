{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  boot.initrd.availableKernelModules = [
    "xhci_pci" "usb_storage" "usbhid"
    "uas"
 ];
  boot.initrd.kernelModules = [ "usb_storage" ];

  environment.systemPackages = with pkgs;
    [
      usbutils
      libusb1
      libusb
      hidapi
    ];
}
