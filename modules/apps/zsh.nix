{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    fastfetch
    exfatprogs
    unzip 
    btop
    htop
    usbutils
    brightnessctl
    nix-tree
    lm_sensors
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    history = {
      size = 1000;
      path = "${config.home.homeDirectory}/.zsh_history";
      ignoreAllDups = true;
    };

    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "bira";
    };
  };
}
