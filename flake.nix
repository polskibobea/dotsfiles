{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    tuigreet-github.url = "github:NotAShelf/tuigreet";
    nvf.url = "github:notashelf/nvf";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
        quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, hjem, spicetify-nix, nvf, quickshell, ...} @ inputs: let
    supportedSystems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    coreModules = [ hjem.nixosModules.default
    ./users
    ];
  in {
    nixosConfigurations = {
      minimal = nixpkgs.lib.nixosSystem {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        specialArgs = {inherit inputs;};
        modules = coreModules ++ [
           nvf.nixosModules.default
           ./hosts/minimal
        ];
      };
      base = nixpkgs.lib.nixosSystem {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        specialArgs = {inherit inputs;};
        modules =
          coreModules
          ++ [
             spicetify-nix.nixosModules.default
            nvf.nixosModules.default
            ./hosts/base
            ./modules
          ];
      };
    };
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
