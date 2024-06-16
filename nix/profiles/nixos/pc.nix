{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../modules/nixos/hardware/io/pci.nix
    ./../../modules/nixos/hardware/io/printer.nix
    ./../../modules/nixos/hardware/io/usb.nix
    ./../../modules/nixos/hardware/io/input.nix
    ./../../modules/nixos/hardware/io/scsi.nix
    ./../../modules/nixos/hardware/io/sd.nix
    ./../../modules/nixos/hardware/io/ssd.nix
    ./../../modules/nixos/hardware/io/ssd-nvme.nix

    ./../../modules/nixos/hardware/video.nix
  ];
}
