{ config, lib, pkgs, inputs, ... }:
let
  mkGenericDefault = lib.mkOverride 1100;
in with lib;
{
    # services.grafana.enable = true;

    services.prometheus = {
        enable = true;
        enableReload = true;
    };
}
