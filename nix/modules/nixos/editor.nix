{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
    programs.neovim.enable = true;
    programs.neovim.defaultEditor = true;

    environment.variables.EDITOR = "nvim";
    environment.sessionVariables.EDITOR = "nvim";
}
