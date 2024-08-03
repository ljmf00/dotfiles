{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  # dependency scripts
  home.file."${config.xdg.configHome}/hypr/scripts/focusworkspace.sh".source =
    ./../../../../dots/wm-hyprland/.config/hypr/focusworkspace.sh;

  wayland.windowManager.hyprland.extraConfig = lib.fileContents ./../../../../dots/wm-hyprland/.config/hypr/hyprland.conf;

  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };

  home.file."${config.xdg.configHome}/waybar/config".source =
    ./../../../../dots/wm-common/.config/waybar/config;

  home.file."${config.xdg.configHome}/waybar/style.css".source =
    ./../../../../dots/wm-common/.config/waybar/style.css;

  home.packages = with pkgs;
    [
      wofi
      kitty
      nautilus
      pavucontrol
    ];
}
