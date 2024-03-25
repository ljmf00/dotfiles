{
  description = "devtty63's dotfiles nix flake";

  inputs = {
    # packages
    nixpkgs.url        = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-23.05";

    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # operating system facilities
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # user configurations
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    # compatibility layer
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, ... }@inputs:
    let
      # default values/parameters
      defaultSystem   = "x86_64-linux";
      defaultHostname = "generic";
      defaultUsername = "luis";

      # system parameters
      system = if builtins ? currentSystem
        then builtins.currentSystem
        else defaultSystem;
      hostname = let host = builtins.getEnv "HOSTNAME";
        in if builtins.stringLength host != 0 then host else defaultHostname;
      username = defaultUsername;

      # alias to system-specific packages
      pkgs = inputs.nixpkgs.legacyPackages.${system};

      python = pkgs.python311;
      pyPkgs = pkgs.python311Packages;

      # =======================================================================

      mkSystem = pkgs: system: hostname:
        pkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./sanix/modules/system.nix
            
            { networking.hostName = hostname; }
            ./hosts/${hostname}/system.nix

            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = { inherit inputs; };

                users.${username} = ./hosts/${hostname}/home.nix;
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };

    in {
      overlays.default = import ./nixos/overlays;

      packages."x86_64-linux"."installer-iso" = (inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;
        modules = [ ./nix/installer ];
      }).config.formats.iso;

      nixosConfigurations = rec {
        thinker = mkSystem inputs.nixpkgs "x86_64-linux" "thinker";
      };

      homeConfigurations.${username} = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./hosts/${hostname}/home.nix
        ];
        extraSpecialArgs = { inherit inputs; };
      };
    };
}
