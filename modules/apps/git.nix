{...}: {
  home-manager.users.bober = {...}: {
    programs.git = {
      enable = true;
      userName = "polskibobea";
      userEmail = "lubiebobea@gmail.com";
    };
  };
}
