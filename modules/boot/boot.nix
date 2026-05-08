{...}:
{
  boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
   system.stateVersion = "26.05";
}
