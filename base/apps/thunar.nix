{pkgs, ...}: {
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.tumbler.enable = true;
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  environment.systemPackages = with pkgs; [
  xfce.tumbler
  ffmpegthumbnailer
  poppler
  libgsf
  vlc
  fontforge
  viewnior
];
}
