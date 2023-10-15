{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../modules/system/hardware/io/ata.nix
    ./../../modules/system/hardware/io/pci.nix
    ./../../modules/system/hardware/io/printer.nix
    ./../../modules/system/hardware/io/usb.nix
    ./../../modules/system/hardware/io/input.nix
    ./../../modules/system/hardware/io/bluetooth.nix
    ./../../modules/system/hardware/io/scsi.nix
    ./../../modules/system/hardware/io/sd.nix
    ./../../modules/system/hardware/io/ssd.nix
    ./../../modules/system/hardware/io/ssd-nvme.nix

    ./../../modules/system/hardware/video.nix
  ];
}
