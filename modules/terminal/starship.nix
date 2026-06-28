{
  programs.starship.enable = true;
  programs.starship.settings = {
    format = "$username@$hostname$directory$nix_shell$git_branch$status$cmd_duration\n$character";
    add_newline = false;

    username = {
      show_always = true;
      format = "[$user](fg:#cba6f7)"; # Mauve (Purple)
    };

    hostname = {
      ssh_only = false;
      format = "[$hostname](fg:#cba6f7)[$ssh_symbol](fg:#a6adc8)"; # Mauve + Subtext0
      ssh_symbol = "";
    };

    directory = {
      format = " [$read_only](fg:#a6adc8)[$path](fg:#cba6f7)"; # Subtext0 + Mauve
      read_only = " ";
    };

    nix_shell.format = " [󱄅 shell](fg:#89b4fa)"; # Blue

    git_branch.format = " [ $branch](fg:#f38ba8)"; # Red

    status = {
      disabled = false;
      format = " [ $int](fg:#f38ba8)"; # Red
    };

    cmd_duration.format = " [$duration](fg:#a6adc8)"; # Subtext0 (fg0)

    character.format = "[λ ](fg:#b4befe)"; # Lavender (Lamba tuff)
  };
}
