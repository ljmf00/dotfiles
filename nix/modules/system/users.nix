{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  # users
  users.users.luis = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.bash;
  };

  nix.settings.trusted-users = [ "root" "luis" ];
  nix.settings.allowed-users = [ "root" "luis" ];
}
