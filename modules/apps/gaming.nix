{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    mangohud
    legcord
    gamescope
    prismlauncher
    heroic
  ];
   programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.gamemode.enable = true;
  hardware.xone.enable = true;
  systemd.user.services.steam-gamescope-session = {
    description = "Steam Big Picture with Gamescope";
    wantedBy = ["graphical-session.target"];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.gamescope}/bin/gamescope -W 1920 -H 1080 -r 60 -- steam -bigpicture";
    };
  };
}
