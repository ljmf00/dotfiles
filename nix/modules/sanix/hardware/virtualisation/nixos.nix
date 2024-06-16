{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  config = mkIf (builtins.elem "virtualisation" config.sanix.hardware) {
      environment.systemPackages = with pkgs;
        [
          spice
          spice-vdagent
        ];

      virtualisation.spiceUSBRedirection.enable = true;
  };
}
