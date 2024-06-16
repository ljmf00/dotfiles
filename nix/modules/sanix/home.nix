{config, pkgs, ... }:
{
  imports = [
    ./.

    ./features/home.nix
  ];
}
