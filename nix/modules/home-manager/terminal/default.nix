{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  imports = [
    ./kitty.nix
    ./shell.nix
    ./tmux.nix
  ];
}
