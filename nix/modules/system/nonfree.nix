{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  nixpkgs.config.allowUnfree = true;
}
