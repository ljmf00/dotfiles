{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
  services.syncthing = {
    enable = true;
    relay.enable = true;

    openDefaultPorts = true;

    overrideFolders = false;
    overrideDevices = false;

    settings = {
      gui = {
        theme = "black";
      };
      options = {
        localAnnounceEnabled = true;
      };
    };
  };

  networking.hosts = {
    "127.0.0.1" = [ "syncthing.local" ];
  };

  services.nginx = {
    virtualHosts."syncthing.local" = {
      listen = [
        { addr = "127.0.0.1"; port = 80; }
      ];

      locations."/" = {
        proxyPass = "http://localhost:8384/";
        recommendedProxySettings = false;

        extraConfig = ''
          proxy_set_header   X-Real-IP $remote_addr;
          proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header   X-Forwarded-Proto $scheme;

          proxy_set_header   Host               localhost;
          proxy_set_header   X-Forwarded-Host   localhost;
          proxy_set_header   X-Forwarded-Server localhost;

          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
        '';
      };
    };
  };
}
