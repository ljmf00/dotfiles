{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  config = mkIf (builtins.elem "graphical-hyprland" config.sanix.features) {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
