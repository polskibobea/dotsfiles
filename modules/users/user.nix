{...}: {
  users.users.bober = {
    isNormalUser = true;
    description = "Bober";
    extraGroups = ["networkmanager" "wheel"];
  };
}
