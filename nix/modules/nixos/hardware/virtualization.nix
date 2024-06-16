{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  # initramfs and kernel settings
  boot.initrd.availableKernelModules =
    [
      "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi"
      "virtio_balloon" "virtio_console" "virtio_rng"
      "9p" "9pnet_virtio"

      "hv_balloon" "hv_netvsc" "hv_storvsc" "hv_utils" "hv_vmbus"
      "hyperv_keyboard"
    ];
}
