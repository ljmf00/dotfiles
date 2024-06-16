{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  config = mkIf (builtins.elem "virtualisation" config.sanix.features) {
      environment.systemPackages = with pkgs;
        [
          virt-manager
        ];

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
