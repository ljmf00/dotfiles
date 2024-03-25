{ config, lib, pkgs, inputs, ... }:
  with lib;
{
    boot.kernelPackages = pkgs.linuxPackages_zen;

    environment.systemPackages = with pkgs;
    [
      # detect Microsoft (DOS) boot sectors / MBRs
      ms-sys
    ];
}
