{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  programs.tmux = {
    enable = true;
    extraConfig = lib.fileContents ./../../../../dots/core/.tmux.conf;
  };
}
