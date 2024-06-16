{ config, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../profiles/home-manager/personal.nix
  ];
}
