{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (nemo-with-extensions.override {
      extensions = with pkgs; [nemo-seahorse];
    })
  ];
  xdg = {
    mime.defaultApplications = {
      "inode/directory" = ["nemo.desktop"];
      "application/x-gnome-saved-search" = ["nemo.desktop"];
    };
  };
}
