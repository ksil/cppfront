{
  description = "A wrapper around cppfront to enable easier builds via cmake";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    cppfront-src = {
      url = "github:hsutter/cppfront";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, cppfront-src, ... }:
    let
      localOverlay = final: prev: {
        cppfront = prev.callPackage ./nix/package.nix {
          inherit cppfront-src;
        };
      };

      pkgsForSystem = system: import nixpkgs {
        overlays = [ localOverlay ];
        config.allowUnfree = true;
        inherit system;
      };

    # https://github.com/numtide/flake-utils#usage for more examples
    in utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ] (system: rec {
      legacyPackages = pkgsForSystem system;
      packages = utils.lib.flattenTree {
        inherit (legacyPackages) cppfront;
      };
      defaultPackage = packages.cppfront;
      hydraJobs = { inherit (legacyPackages) cppfront; };
      checks = { inherit (legacyPackages) cppfront; };
  }) // {
    # non-system suffixed items should go here
    overlays = {
      default = localOverlay;
    };
    nixosModule = { config, ... }: { options = {}; config = {};}; # export single module
    nixosModules = {}; # attr set or list
    nixosConfigurations.hostname = { config, pkgs, ... }: {};
  };
}