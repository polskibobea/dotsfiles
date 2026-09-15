{ pkgs, ... }:

{
  # Dotychczasowa konfiguracja
  networking.hostId = "4e98920d";
  boot.zfs.forceImportRoot = false;
  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  i18n.defaultLocale = "pl_PL.UTF-8";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "26.05";

  # --- Wsparcie dla XFCE i X11 ---
  services.xserver = {
    enable = true;
    
    # Menedżer logowania i środowisko XFCE
    displayManager.lightdm.enable = true;
    desktopManager.xfce.enable = true;

    # Ustawienia klawiatury (układ polski)
    xkb = {
      layout = "pl";
      variant = "";
    };
  };

  # Obsługa dźwięku (PipeWire - standard w nowoczesnym Linuksie)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Przydatne aplikacje i aplety dla XFCE
  environment.systemPackages = with pkgs; [
    xfce.xfce4-pulseaudio-plugin # Aplet głośności w panelu
    xfce.xfce4-whiskermenu-plugin # Nowoczesne menu start
    pavucontrol                  # Mikser audio
  ];
}
