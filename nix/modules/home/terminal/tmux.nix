{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    extraConfig = lib.fileContents ./../../../../dots/core/.tmux.conf;
  };
}
