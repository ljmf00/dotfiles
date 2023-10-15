{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  config = mkIf (builtins.elem "graphical-gnome" config.sanix.features) {
    # Enable the GNOME Desktop Environment.
    services.xserver.desktopManager.gnome.enable = true;

    services.gnome = {
        # General settings
        gnome-initial-setup.enable = false;
        gnome-keyring.enable = true;
        gnome-online-accounts.enable = true;
        gnome-remote-desktop.enable = true;
        gnome-settings-daemon.enable = true;
        gnome-user-share.enable = true;

        rygel.enable = true;
        sushi.enable = true;

        # File trackers and information miners
        gnome-online-miners.enable = true;
        tracker.enable = true;
        tracker-miners.enable = true;
    };

    # Enable gnome theme on QT
    qt.platformTheme = "gnome";
  };
}