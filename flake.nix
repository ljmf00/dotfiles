{
  description = "devtty63's dotfiles nix flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = if builtins ? currentSystem then builtins.currentSystem else "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      hostname = let host = builtins.getEnv "HOSTNAME";
        in if builtins.stringLength host != 0 then host else "generic";

      mkSystem = pkgs: system: hostname:
        pkgs.lib.nixosSystem {
          system = system;
          modules = [
            { networking.hostName = hostname; }
            ./hosts/${hostname}/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = { inherit inputs; };
                users.luis = ./hosts/${hostname}/home.nix;
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };

    in {
      # include nixpkgs overlays
      nixpkgs.overlays = [
        inputs.nur.overlay
        (import ./nixos/overlays)
      ];

      # nixos installer iso
      nixosInstallerIso = (nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;
        modules = [ ./nixos/installer/configuration.nix ];
      }).config.formats.iso;

      nixosConfigurations = {
        thinker = mkSystem nixpkgs "x86_64-linux" "thinker";
      };

      homeConfigurations.luis = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./hosts/${hostname}/home.nix
        ];
        extraSpecialArgs = { inherit inputs; };
      };
    };
}
