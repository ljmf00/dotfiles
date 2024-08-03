{ config, lib, ... }:

{
  services.tlp.enable = lib.mkDefault ((lib.versionOlder (lib.versions.majorMinor lib.version) "21.05")
                                       || !config.services.power-profiles-daemon.enable);

  services.thermald.enable = true;
  services.auto-cpufreq.enable = false;
  services.power-profiles-daemon.enable = true;
  services.logind.lidSwitchExternalPower = "ignore";
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };
}
