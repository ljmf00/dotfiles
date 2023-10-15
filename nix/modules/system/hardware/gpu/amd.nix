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

  hardware.opengl.extraPackages = with pkgs; [
      amdvlk
    ] ++
    (
      if pkgs ? rocmPackages.clr
      then with pkgs.rocmPackages; [ clr clr.icd ]
      else with pkgs; [ rocm-opencl-icd rocm-opencl-runtime ]
    );
  
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
}