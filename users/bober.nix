{
  inputs,
  config,
  ...
}: let
  inherit (inputs.hjem) packages;
  inherit (config.nixpkgs.hostPlatform) system;
in {
  hjem = {
    users.bober = {
      user = "bober";
      directory = "/home/bober";
    };
    clobberByDefault = true;
    linker = packages.${system}.smfh;
  

  };
    users.users.bober = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
}
