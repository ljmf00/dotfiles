{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  security = {
    # disable sudo and enable doas
    sudo.enable = false;

    doas = {
      enable = true;
      extraRules = [{
        users = [ "luis" ];
        keepEnv = true;
        persist = true;
      }];
    };
  };
}
