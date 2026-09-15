{...}:
{
  networking.hostId = "4e98920d";
  boot.zfs.forceImportRoot = false;
  nix.settings.experimental-features = ["flakes" "nix-command"];
  i18n.defaultLocale = "pl_PL.UTF-8";
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
}
