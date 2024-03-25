{ config, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../nix/profiles/home/personal.nix
  ];
}