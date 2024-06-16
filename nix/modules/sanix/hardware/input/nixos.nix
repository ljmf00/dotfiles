{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  config = mkIf (builtins.elem "input" config.sanix.hardware) {
      environment.systemPackages = with pkgs;
        [
          virt-manager
          spice
          spice-vdagent
        ];

      virtualisation.spiceUSBRedirection.enable = true;

      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [pkgs.OVMF.fd];
          };
        };
      };
  };
}
