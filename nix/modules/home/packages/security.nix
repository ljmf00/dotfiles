{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  home.packages = with pkgs;
    [
      keepassxc
    ];
}
