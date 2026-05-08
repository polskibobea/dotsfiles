{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nvf.url = "github:NotAShelf/nvf";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    home-manager,
    nvf,
    spicetify-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.bobrowniki = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      specialArgs = {inherit inputs system;};
      modules = [
        ./modules/import.nix
        spicetify-nix.nixosModules.spicetify
        #./configruation.nix
        nvf.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.bober = import ./modules/users/hmuser.nix;
            extraSpecialArgs = {inherit inputs;};
          };
        }
      ];
    };
    formatter.${system} = pkgs.alejandra;
  };
}
