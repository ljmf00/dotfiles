{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  # enable fontconfig
  fonts.fontconfig.enable = true;

  # add fonts
  fonts.packages = with pkgs; [
      corefonts

      dejavu_fonts

      noto-fonts
      noto-fonts-emoji

      noto-fonts-lgc-plus
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-extra

      inconsolata
      fira-code-symbols
      font-awesome

      ubuntu_font_family
      liberation_ttf
      roboto-mono
      roboto
  ];

  # console settings
  console.packages = with pkgs;
    [
      terminus_font
    ];

  console.font = "Lat2-Terminus16";
  console.useXkbConfig = true;
}
