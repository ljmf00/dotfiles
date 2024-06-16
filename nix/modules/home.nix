{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./home
    ./sanix/home.nix
  ];
}
