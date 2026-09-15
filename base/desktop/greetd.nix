{
  pkgs,
  inputs,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${inputs.tuigreet-github.packages.${pkgs.system}.default}/bin/tuigreet --time --remember --remember-session -w 80 --cmd start-hyprland";
        user = "greeter";
      };
    };
  };
}
