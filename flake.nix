{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    home-manager,
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
        #./configruation.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.bober = import .modules/users/user.nix;
            extraSpecialArgs = {inherit inputs;};
          };
        }
      ];
    };
    formatter.${system} = pkgs.alejandra;
  };
}
