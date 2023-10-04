{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./local-scripts
  ];

  home.packages = with pkgs;
    [
      # GUI support
      neovim-qt
    ];

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
        max_line_width = 80;
        indent_style = "space";
        indent_size = 4;
      };
    };
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;

    # Aliases
    viAlias      = true;
    vimAlias     = true;
    vimdiffAlias = true;

    # Providers
    withNodeJs  = true;
    withPython3 = true;
    withRuby    = true;
  };

  home.sessionVariables = {
    "EDITOR" = "$HOME/.local/bin/editor";
  };
  home.shellAliases = {
    "v" = "$EDITOR";
  };
}
