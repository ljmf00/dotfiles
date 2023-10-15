{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  home.packages = with pkgs;
    [
      # Media settings
      pavucontrol

      # Media players
      mpv
      vlc

      # Audio specific
      audacious
      tenacity
      ardour
    ];
}
