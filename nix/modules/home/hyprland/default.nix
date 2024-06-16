{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  # dependency scripts
  home.file."${config.xdg.configHome}/hypr/scripts/focusworkspace.sh".source =
    ./focusworkspace.sh;

  wayland.windowManager.hyprland.extraConfig = lib.fileContents ./hyprland.conf;
}
