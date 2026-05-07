{config,...}:
{
  services.zfs.autoScrub.enable = true;
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
  networking.hostId = builtins.substring 0 8 (builtins.hashString "sha256" config.networking.hostName);
}
