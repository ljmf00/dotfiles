{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  # protect the kernel image
  security.protectKernelImage = true;

  # enable apparmor
  # security.apparmor.enable = true;

  # enable sudo
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  # enable gnupg agent
  programs.gnupg.agent.enable = true;

  # Smartcard
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization ];

  # override the system memory allocator
  # environment.memoryAllocator.provider = "scudo";
}
