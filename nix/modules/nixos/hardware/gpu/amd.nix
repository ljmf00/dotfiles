{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  imports = [
    ./.
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "amdgpu" ];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  services.xserver.videoDrivers = mkGenericDefault [ "amdgpu" "radeon" ];

  hardware.graphics.extraPackages = with pkgs; [
      amdvlk
    ] ++
    (
      if pkgs ? rocmPackages.clr
      then with pkgs.rocmPackages; [ clr clr.icd ]
      else with pkgs; [ rocm-opencl-icd rocm-opencl-runtime ]
    );

  hardware.graphics.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };
}
