{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../modules/home-manager/basic.nix
    ./../../modules/home-manager/terminal
    ./../../modules/home-manager/local-scripts
    ./../../modules/home-manager/keys.nix
  ];

  home.username = "luis";
  home.homeDirectory = "/home/luis";

  home.keyboard.layout = "us";

  home.enableNixpkgsReleaseCheck = true;
  home.extraOutputsToInstall =
    [
      "doc"
      "info"
      "devdoc"
    ];

  programs.home-manager.enable = true;
}
