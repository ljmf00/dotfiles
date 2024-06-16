{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;

  kver = config.boot.kernelPackages.kernel.version;
in with lib;
{
  imports = [
    ./amd.nix
  ];

  powerManagement = mkMerge [
    (mkIf
      (
        (versionAtLeast kver "5.17")
        && (versionOlder kver "6.1")
      )
      {
        cpuFreqGovernor = mkGenericDefault "powersave";
      })
  ];

  boot = mkMerge [
    (mkIf
      (
        (versionAtLeast kver "5.17")
        && (versionOlder kver "6.1")
      )
      {
        kernelParams = [ "initcall_blacklist=acpi_cpufreq_init" ];
        kernelModules = [ "amd-pstate" ];
      })
    (mkIf
      (
        (versionAtLeast kver "6.1")
        && (versionOlder kver "6.3")
      )
      {
        kernelParams = [ "amd_pstate=passive" ];
      })
    (mkIf (versionAtLeast kver "6.3") {
      kernelParams = [ "amd_pstate=active" ];
    })
  ];
}
