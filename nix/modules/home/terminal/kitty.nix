{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  programs.kitty = {
    enable = true;
    extraConfig = lib.fileContents ./../../../../dots/kitty/.config/kitty/kitty.conf;
  };
}
