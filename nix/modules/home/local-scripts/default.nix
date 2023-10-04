{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.file.".local/bin/editor".source = ./files/editor;
  home.file.".local/bin/box".source = ./files/box;
  home.file.".local/bin/dotfiles".source = ./files/dotfiles;
  home.file.".local/bin/download".source = ./files/download;
  home.file.".local/bin/extract".source = ./files/extract;
  home.file.".local/bin/popup".source = ./files/popup;
  home.file.".local/bin/remote".source = ./files/remote;
  home.file.".local/bin/safe".source = ./files/safe;
  home.file.".local/bin/service".source = ./files/service;
  home.file.".local/bin/session".source = ./files/session;
  home.file.".local/bin/terminal".source = ./files/terminal;
  home.file.".local/bin/win".source = ./files/win;
}
