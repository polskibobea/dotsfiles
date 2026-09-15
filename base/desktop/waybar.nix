{
  config,
  pkgs,
  ...
}: {
  home-manager.users.bober = {...}: {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          margin-top = 5;
          margin-left = 10;
          margin-right = 10;
          modules-left = ["hyprland/workspaces" "hyprland/window"];
          modules-center = ["clock"];
          modules-right = [
            "pulseaudio"
            "network"
            "cpu"
            "memory"
            "battery"
            "tray"
            "custom/power"
          ];

          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            format = "{name}";
          };

          "clock" = {
            format = "{:%H:%M}  ";
            format-alt = "{:%A, %B %d, %Y}  ";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
          };

          "cpu" = {
            format = "{usage}% ";
            tooltip = false;
          };

          "memory" = {
            format = "{}% ";
          };

          "battery" = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% ";
            format-plugged = "{capacity}% ";
            format-icons = ["" "" "" "" ""];
          };

          "network" = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "Connected ";
            format-disconnected = "Disconnected ⚠";
          };

          "pulseaudio" = {
            format = "{volume}% {icon}";
            format-bluetooth = "{volume}% {icon}";
            format-muted = "";
            format-icons = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = ["" ""];
            };
            on-click = "pavucontrol";
          };

          "custom/power" = {
            format = "⏻";
            on-click = "wlogout";
            tooltip = false;
          };
        };
      };

      style = ''
        * {
            border: none;
            border-radius: 0;
            font-family: "JetBrainsMono Nerd Font";
            font-size: 13px;
            min-height: 0;
        }

        window#waybar {
            background: rgba(21, 18, 27, 0.9);
            color: #cdd6f4;
            transition-property: background-color;
            transition-duration: .5s;
            border-radius: 10px;
        }

        #workspaces button {
            padding: 0 5px;
            background: transparent;
            color: #cdd6f4;
            border-bottom: 3px solid transparent;
        }

        #workspaces button.active {
            background: #313244;
            border-bottom: 3px solid #cdd6f4;
        }

        #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #custom-power {
            padding: 0 10px;
            margin: 0 4px;
            color: #cdd6f4;
            background-color: #313244;
            border-radius: 8px;
        }

        #custom-power {
            color: #f38ba8;
            font-size: 15px;
        }
      '';
    };
  };
}
