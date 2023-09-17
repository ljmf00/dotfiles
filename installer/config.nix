{config, nixos-generators, ...}: {
  imports = [
    nixos-generators.nixosModules.all-formats
  ];

  formatConfigs.iso = { config, lib, pkgs, modulesPath, options, ... }:
    with lib;
  {

    imports = [
      "${toString modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    ];

    isoImage.isoName = mkDefault "installer.iso";
    isoImage.volumeID = substring 0 11 "INSTALLISO";
    isoImage.makeEfiBootable = true;
    isoImage.makeUsbBootable = true;

    system.stateVersion = lib.mkDefault lib.trivial.release;

    boot.loader.grub.memtest86.enable = true;
    boot.kernelPackages = mkDefault config.boot.zfs.package.latestCompatibleLinuxPackages;

    documentation.enable = mkDefault false;
    documentation.nixos.enable = mkDefault false;

    networking.networkmanager.enable = true;
    networking.wireless.enable = mkDefault true;
    networking.wireless.userControlled.enable = true;
    systemd.services.wpa_supplicant.wantedBy = mkOverride 50 [];

    services.xserver.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.displayManager = {
      gdm = {
        enable = true;
        autoSuspend = false;
      };

      autoLogin = {
        enable = true;
        user = "nixos";
      };
    };

    services.openssh = {
      enable = mkDefault false;
      settings.PermitRootLogin = mkDefault "no";
    };

    security.sudo = {
      enable = mkDefault true;
      wheelNeedsPassword = mkImageMediaOverride false;
    };

    security.unprivilegedUsernsClone = mkDefault config.virtualisation.containers.enable;
    security.virtualisation.flushL1DataCache = mkDefault "always";
    security.apparmor.enable = mkDefault true;
    security.apparmor.killUnconfinedConfinables = mkDefault true;

    powerManagement.enable = true;
    hardware.pulseaudio.enable = true;
    hardware.enableRedistributableFirmware = true;

    environment.variables.GC_INITIAL_HEAP_SIZE = "1M";

    swapDevices = mkImageMediaOverride [ ];
    fileSystems = mkImageMediaOverride config.lib.isoFileSystems;

    fonts.fontconfig.enable = true;

    console.packages = options.console.packages.default ++ [ pkgs.terminus_font ];
    environment.systemPackages = [
      pkgs.w3m-nographics
      pkgs.testdisk
      pkgs.ms-sys
      pkgs.efibootmgr
      pkgs.efivar
      pkgs.parted
      pkgs.gptfdisk
      pkgs.ddrescue
      pkgs.ccrypt
      pkgs.cryptsetup

      pkgs.gparted
      pkgs.sdparm
      pkgs.hdparm
      pkgs.smartmontools
      pkgs.pciutils
      pkgs.usbutils
      pkgs.nvme-cli

      pkgs.fuse
      pkgs.fuse3
      pkgs.sshfs-fuse
      pkgs.socat
      pkgs.tmux
      pkgs.tcpdump

      pkgs.neovim
      pkgs.git
      pkgs.firefox

      pkgs.unzip
      pkgs.zip
    ];

    system.extraDependencies = with pkgs;
      [
        stdenv
        stdenvNoCC
        busybox
        jq
        makeInitrdNGTool
        systemdStage1
        systemdStage1Network
      ];

    boot.swraid.enable = true;
    nix.settings.trusted-users = [ "root" "nixos" ];
  };
}
