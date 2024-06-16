{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../modules/home-manager/editor
    ./../../modules/home-manager/cli.nix
    ./../../modules/home-manager/git.nix
  ];
}
