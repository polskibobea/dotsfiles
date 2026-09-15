{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = ["btusb"];
  boot.extraModulePackages = [];

fileSystems."/" =
  { device = "rpool/nixos/root";
    fsType = "zfs";
  };
fileSystems."/nix" =
{ device = "rpool/nixos/nix";
fsType = "zfs";
neededForBoot = true;
};
fileSystems."/home" =
  { device = "rpool/nixos/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };
  swapDevices = [];


  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
