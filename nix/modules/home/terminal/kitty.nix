{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  programs.kitty = {
    enable = true;
    extraConfig = lib.fileContents ./../../../../dots/kitty/.config/kitty/kitty.conf;
  };

  dconf.settings = {
    "org.gnome.desktop.default-applications.terminal" = {
      exec = "kitty";
      exec-arg = "";
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Alt>T";
      command = "kitty";
      name = "Open 'kitty' Terminal";
    };
  };
}
