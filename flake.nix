{
  description = "devtty63's dotfiles nix flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixos-generators, ... }@attrs: {

    # nixos installer iso
    nixosInstallerIso = (nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./installer/config.nix ];
    }).config.formats.iso;

  };
}
