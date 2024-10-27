{ config, lib, pkgs, inputs, ... }:
  with lib;
{
    imports = [
      ./../../kernel
    ];

    boot.kernelPackages = pkgs.linuxPackages_custom;

    environment.systemPackages = with pkgs;
    [
      # detect Microsoft (DOS) boot sectors / MBRs
      ms-sys
    ];
}
