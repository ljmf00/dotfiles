{ config, lib, pkgs, inputs, ... }:
  with lib;
{
    services.udisks2.enable = true;
    services.gvfs.enable = true;

    environment.systemPackages = with pkgs;
    [
      fuse
      fuse3
      sshfs-fuse

      # disk analysis tools
      sdparm
      hdparm
    ];

    boot.supportedFilesystems =
      [
        # normal user filesystems
        "ext4" "f2fs" "ntfs" "xfs"

        # other filesystems
        "cifs"  "jfs"  "reiserfs"
      ];
}
