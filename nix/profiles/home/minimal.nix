{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../modules/home/terminal
    ./../../modules/home/local-scripts
    ./../../modules/home/keys.nix
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
