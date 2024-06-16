{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../modules/home/editor
    ./../../modules/home/cli.nix
    ./../../modules/home/git.nix
  ];
}
