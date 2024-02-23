{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  home.packages = with pkgs;
  [
    pre-commit
  ];

  programs.git = {
    enable = true;
    delta.enable = true;
    lfs.enable = true;

    package = pkgs.gitFull;

    userName = "Luís Ferreira";
    userEmail = "contact@lsferreira.net";

    signing = {
      key = "730750D54B7A9F66";
      signByDefault = false;
    };

    aliases = {
      "s" = "status";

      "c" = "commit -s";
      "ca-sign" = "commit -s --amend --no-edit";
      "cp" = "cherry-pick";

      "b" = "branch";
    };

    ignores = [
      "*~"
      "*.swp"
      "Session.vim"
    ];

    attributes = [
      "*.pdf diff=pdf"
    ];

    extraConfig = {
      core = {
        editor = "nvim --clean";
        whitespace = "trailing-space,space-before-tab";
        commitGraph = true;
      };
    };
  };

  programs.git-cliff.enable = true;
  programs.gitui.enable = true;
  programs.gh.enable = true;
}
