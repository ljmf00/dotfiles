{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  home.packages = with pkgs;
    [
      dejavu_fonts
      nerd-fonts.roboto-mono
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.ubuntu-mono
      nerd-fonts.droid-sans-mono
      nerd-fonts.inconsolata

      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
    ];

  fonts.fontconfig.enable = true;
}
