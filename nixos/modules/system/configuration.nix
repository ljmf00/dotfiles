{ config, lib, pkgs, inputs, ... }:

{
  system.stateVersion = "23.05";

  # users
  users.users.luis = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.bash;
  };
}
