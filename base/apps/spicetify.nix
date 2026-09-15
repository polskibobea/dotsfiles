{pkgs,config,inputs, ... }:

   let
     spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
   in
  { 
   programs.spicetify = {
     enable = true;
     enabledExtensions = with spicePkgs.extensions; [
       adblockify
     ];
     theme = spicePkgs.themes.catppuccin;
     colorScheme = "mocha";
   };
   }
