{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  services.xserver.videoDrivers = mkGenericDefault [ "modesetting" "vesa" ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.graphics = {
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      mesa.drivers
    ];
  };

  environment.systemPackages = with pkgs; [
    libva-utils
    glxinfo
  ];
}
