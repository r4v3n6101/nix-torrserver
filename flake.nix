{
  description = "Modules for TorrServer";

  inputs = {
    nixpkgs.url = "github:r4v3n6101/nixpkgs/torrserver";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (system: {
      packages.default = (import nixpkgs { inherit system; }).torrserver;
    })
    // {
      darwinModules.default =
        { pkgs, lib, ... }:
        let
          torrserver = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
        in
        {
          imports = [
            (import ./options.nix { inherit lib torrserver; })
            ./darwin.nix
          ];
        };
    }
    // {
      nixosModules.default =
        { pkgs, lib, ... }:
        let
          torrserver = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
        in
        {
          imports = [
            (import ./options.nix { inherit lib torrserver; })
            ./nixos.nix
          ];

        };
    };
}
