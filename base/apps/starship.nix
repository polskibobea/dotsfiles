{
  pkgs,
  config,
  ...
}: {
  home-manager.users.bober = {...}: {
    home.packages = [pkgs.eza];

    programs.starship = {
      enable = true;
      settings = {
        format = "$username@$hostname$directory$nix_shell$git_branch$status$cmd_duration\n$character";
        add_newline = false;

        username = {
          show_always = true;
          format = "[$user](fg:#cba6f7)"; # Mauve
        };

        hostname = {
          ssh_only = false;
          format = "[$hostname](fg:#cba6f7)[$ssh_symbol](fg:#a6adc8)";
          ssh_symbol = "";
        };

        directory = {
          format = " [$read_only](fg:#a6adc8)[$path](fg:#cba6f7)";
          read_only = " ";
        };

        nix_shell.format = " [󱄅 shell](fg:#89b4fa)"; # Blue
        git_branch.format = " [ $branch](fg:#f38ba8)"; # Red

        status = {
          disabled = false;
          format = " [ $int](fg:#f38ba8)";
        };

        cmd_duration.format = " [$duration](fg:#a6adc8)";
        character.format = "[λ ](fg:#b4befe)"; # Lavender
      };
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true; # Uwaga: w nowszych wersjach HM to 'autosuggestion.enable', nie 'autosuggestions'
      syntaxHighlighting.enable = true;

      history = {
        size = 10000;
        path = "${config.home.homeDirectory}/.zsh_history";
        ignoreAllDups = true;
        share = true;
      };

      shellAliases = {
        ls = "eza --icons --color=always --group-directories-first";
        ll = "eza -l --icons --color=always --group-directories-first";
      };
    };
  };
}
