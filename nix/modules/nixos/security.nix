{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  # protect the kernel image
  security.protectKernelImage = true;

  # enable apparmor
  # security.apparmor.enable = true;

  # use sandbox
  nix.settings.sandbox = true;

  # enable sudo
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  # enable gnupg agent
  programs.gnupg.agent = {
    enable                = true;
    enableExtraSocket     = true;
    enableBrowserSocket   = true;
    enableSSHSupport      = true;

    pinentryPackage = pkgs.pinentry-curses;
  };

  # Smartcard
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization ];

  # override the system memory allocator
  # environment.memoryAllocator.provider = "scudo";

  # can leak valuable information
  systemd.coredump.enable = false;

  # enable suid sandbox on chromium
  security.chromiumSuidSandbox.enable = true;

  # enable firejail
  programs.firejail.enable = true;

  # use clamav
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;

  # raise the soft limits
  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "4096";
  }];
}
