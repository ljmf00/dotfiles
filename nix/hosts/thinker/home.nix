{ config, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../profiles/home/personal.nix
  ];
}
