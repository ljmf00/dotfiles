{config, nixos-generators, ...}: {
  imports = [
    nixos-generators.nixosModules.all-formats
  ];

  formatConfigs.iso = { config, lib, pkgs, modulesPath, options, ... }:
    with lib;
  {

    imports = [
      "${toString modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
      "${toString modulesPath}/installer/cd-dvd/channel.nix"
      "${toString modulesPath}/profiles/qemu-guest.nix"
    ];

    # metadata
    system.stateVersion = mkDefault lib.trivial.release;
    system.nixos.variant_id = mkDefault "installer";

    # iso image settings
    isoImage.isoName = mkForce "installer.iso";
    isoImage.squashfsCompression = "gzip -Xcompression-level 1";
    isoImage.volumeID = substring 0 11 "INSTALLISO";
    isoImage.makeEfiBootable = true;
    isoImage.makeUsbBootable = true;

    # disk layout
    swapDevices = mkImageMediaOverride [ ];
    fileSystems = mkImageMediaOverride config.lib.isoFileSystems;

    # documentation
    documentation.enable = mkImageMediaOverride true;
    documentation.nixos.enable = mkImageMediaOverride true;

    # virtualization settings
    virtualisation.spiceUSBRedirection.enable = true;
    virtualisation.hypervGuest.enable = true;
    virtualisation.vmware.guest.enable = true;

    # services
    services.qemuGuest.enable = true;
    services.xserver = {
      enable = true;

      desktopManager.gnome.enable = true;
      displayManager = {
        gdm = {
          enable = true;
          autoSuspend = false;
        };

        autoLogin = {
          enable = true;
          user = "nixos";
        };
      };
    };

    # security-related changes
    services.openssh = {
      enable = mkForce false;
      settings.PermitRootLogin = mkForce "no";
    };

    security.sudo = {
      enable = mkForce true;
      wheelNeedsPassword = mkImageMediaOverride false;
    };

    security.unprivilegedUsernsClone = mkDefault config.virtualisation.containers.enable;
    security.virtualisation.flushL1DataCache = mkDefault "always";
    security.apparmor.enable = mkDefault true;
    security.apparmor.killUnconfinedConfinables = mkDefault true;
    nix.settings.trusted-users = [ "root" "nixos" ];

    powerManagement.enable = true;

    environment.variables.GC_INITIAL_HEAP_SIZE = "1M";

    fonts.fontconfig.enable = true;

    # packages

    # console packages
    console.packages = with pkgs;
      [
        terminus_font
      ];

    # system packages
    environment.systemPackages = with pkgs;
      [
        w3m-nographics
        testdisk
        ms-sys
        efibootmgr
        efivar
        parted
        gptfdisk
        ddrescue
        ccrypt
        cryptsetup

        gparted
        sdparm
        hdparm
        smartmontools
        pciutils
        usbutils
        nvme-cli

        fuse
        fuse3
        sshfs-fuse
        socat
        tmux
        tcpdump

        neovim
        git
        firefox

        unzip
        zip
      ];

    system.extraDependencies = with pkgs;
      [
        stdenv
        stdenvNoCC
        busybox
        jq
        makeInitrdNGTool
      ];
  };
}
