{...}: {
  imports = [
    ./hardware-configuration.nix
    ./zfs.nix
    ./boot.nix
    ./nvidia.nix
  ];
}
