{ config, lib, pkgs, inputs, ... }:
  with lib;
{
    # early boot-related settings
    boot.loader.grub.memtest86.enable = true;

    # initramfs and kernel settings
    boot.initrd.availableKernelModules =
      [
        "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi"
        "virtio_balloon" "virtio_console" "virtio_rng"
        "9p" "9pnet_virtio"

        "hv_balloon" "hv_netvsc" "hv_storvsc" "hv_utils" "hv_vmbus"
        "hyperv_keyboard"
      ];
    boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    boot.swraid.enable = true;
    boot.supportedFilesystems =
      [
        # normal user filesystems
        "btrfs" "ext4" "f2fs" "ntfs" "vfat" "xfs"

        # add zfs support
        "zfs"

        # other filesystems
        "cifs"  "jfs"  "reiserfs"
      ];
}
