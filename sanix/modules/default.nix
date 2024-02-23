{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  options = {
    sanix.hardware = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "cpu-amd-zen3" ];
      description = lib.mdDoc "Hardware available on the current nix environment";
    };

    sanix.features = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "graphical-gnome" ];
      description = lib.mdDoc "Features to install on the current nix environment";
    };
  };
}