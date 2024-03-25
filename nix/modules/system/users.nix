{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  services.syncthing.user = "luis";
  services.syncthing.dataDir = "/home/luis";

  # users
  users.mutableUsers = true;
  users.users.luis = {
    isNormalUser = true;
    uid = 1000;

    createHome = true;
    home = "/home/luis";

    shell = pkgs.bash;

    group = "users";
    extraGroups = [
      "wheel"

      "kvm" "vboxusers" "docker" "libvirtd"

      "video" "audio"

      "bluetooth" "lp" "networkmanager"

      "adbusers" 
      
      "plugdev" "dialout"
    ];
  };

  users.defaultUserShell = pkgs.bash;

  nix.settings.trusted-users = [ "root" "luis" "@wheel" ];
  nix.settings.allowed-users = [ "root" "luis" "@wheel" ];

  xdg.autostart.enable = true;
  xdg.mime.enable = true;
}
