{ config, lib, pkgs, inputs, ...}:
  with lib;
{
  imports = [
    ./../../modules/nixos/hardware/cpu/amd-zen3.nix
    ./../../modules/nixos/hardware/gpu/amd.nix

    ./../../modules/nixos/hardware/efi/nonesp.nix

    ./../../modules/nixos/hardware/boot/luks.nix
    ./../../modules/nixos/hardware/boot/btrfs.nix
    ./../../modules/nixos/hardware/boot/swap.nix

    ./../../modules/nixos/hardware/io/ssd-nvme.nix
    ./../../modules/nixos/hardware/virtualization.nix

    ./../../modules/nixos/unfree.nix

    ./../../profiles/nixos/laptop.nix
    ./../../profiles/nixos/personal.nix

    ./../../profiles/sanix/laptop.nix
  ];

  nix.settings.system-features = [ "nixos-test" "benchmark" "big-parallel" ];

  boot.kernelParams = [
    # Force use of the thinkpad_acpi driver for backlight control.
    # This allows the backlight save/load systemd service to work.
    "acpi_backlight=native"

    # With BIOS version 1.12 and the IOMMU enabled, the amdgpu driver
    # either crashes or is not able to attach to the GPU depending on
    # the kernel version. I've seen no issues with the IOMMU disabled.
    #
    # BIOS version 1.13 fixes the IOMMU issues, but we leave the IOMMU
    # in software mode to avoid a sad experience for those people that drew
    # the short straw when they bought their laptop.
    #
    # Do not set iommu=off, because this will cause the SD-Card reader
    # driver to kernel panic.
    # "iommu=soft"
  ];

  # "hardware-x86_64" "hardware-x86_64-kvm"
  # "hardware-x86_64-amd"
  # "hardware-emulate-arm" "hardware-emulate-riscv" "hardware-emulate-wasm"

  # hardware-bluetooth
  # hardware-ssd hardware-ssd-nvme
  # hardware-usb

  # documentation
  sanix.hardware = [
    "cpu-x86_64-amd-zen3" "gpu-amd" "audio" "usb" "wifi" "ethernet" "bluetooth"
  ];

  sanix.features = [
    "unfree" "hardening"
    "documentation" "fonts"

    "graphical-gnome"
  ];

  environment.systemPackages = with pkgs;
    [
      kitty
      virt-manager
      spice
      spice-vdagent
    ];

  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [pkgs.OVMF.fd];
      };
    };
  };
}
