{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  services.tor = {
    enable = true;

    client = {
      enable = true;
      dns.enable = true;
      transparentProxy.enable = true;
    };

    relay.enable = false;
  };

  services.privoxy = {
    enable = true;
    enableTor = true;
  };

  services.nginx = {
    enable = true;
    enableReload = true;

    statusPage = true;

    recommendedGzipSettings = true;
    recommendedZstdSettings = true;
    recommendedBrotliSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;

    defaultListen = [
      { addr = "127.0.0.1"; port = 80; }
    ];

    virtualHosts."_" = {
      default = true;

      listen = [
        { addr = "0.0.0.0"; port = 80; }
      ];

      locations."/" = {
        return = "200 'Nothing to see here.'";
        extraConfig = ''
          default_type text/plain;
        '';
      };
    };

    virtualHosts."localhost" = {
      listen = [
        { addr = "127.0.0.1"; port = 80; }
      ];

      locations."/" = {
        return = "200 'Nothing to see here.'";
        extraConfig = ''
          default_type text/plain;
        '';
      };
    };
  };
}
