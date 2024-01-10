{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  services.gpg-agent.pinentryFlavor = mkDefault "gtk2";

  home.packages = with pkgs;
    [
      firefox
    ];

  gtk = {
    enable = true;

    theme.name    = "Adwaita-Dark";
    theme.package = pkgs.gnome.gnome-themes-extra;

    iconTheme.name    = "Papirus-Dark";
    iconTheme.package = pkgs.papirus-icon-theme;
  };

  dconf.settings = {
    # Theme
    "org/gnome/desktop/interface"."color-scheme" = "prefer-dark";

    # disable first-setup messages
    "org/gnome/software"."first-run" = false;

    # Setting hot corners
    "org/gnome/shell"."enable-hot-corners" = false;
    "org/gnome/desktop/interface"."enable-hot-corners" = false;

    # Animations
    "org/gnome/desktop/interface"."enable-animations" = true;

    # Clock, Locale and Calendar
    "org/gnome/desktop/interface"."clock-format" = "24h";
    "org/gnome/desktop/interface"."clock-show-seconds" = true;
    "org/gnome/desktop/interface"."clock-show-weekday" = true;
    "org/gnome/desktop/interface"."clock-show-date" = true;
    "org/gnome/desktop/calendar"."show-weekdate" = true;
    "org/gnome/shell/weather"."automatic-location" = true;
    "org/gnome/system/location".enabled = true;
  };
}
