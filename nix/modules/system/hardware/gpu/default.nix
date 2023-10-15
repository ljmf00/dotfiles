{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  services.xserver.videoDrivers = mkGenericDefault [ "modesetting" ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];

    driSupport = true;
    driSupport32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    libva-utils
  ];
}