{ config, lib, pkgs, modulesPath, ... }:
{
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot = {
        initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
        initrd.kernelModules = [ "amdgpu" ];
        kernelModules = [ "wireguard" "kvm-amd" "msr" ];
        extraModulePackages = [ ];
    };
}
