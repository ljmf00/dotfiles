{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  boot.plymouth.enable = true;
  
  boot.kernelParams = [ "splash" "quiet" ];

  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };
}