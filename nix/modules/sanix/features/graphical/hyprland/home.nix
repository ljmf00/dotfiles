{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  config = mkIf (builtins.elem "graphical-hyprland" config.sanix.features) {
    wayland.windowManager.hyprland = {
      enable = true;
    };
  };
}
