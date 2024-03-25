{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  home.packages = with pkgs;
    [
      dejavu_fonts
      nerdfonts

      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk
    ];

  fonts.fontconfig.enable = true;
}
