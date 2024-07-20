{
  pkgs,
  lib,
  host,
  config,
  ...
}: let
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
  inherit (import ../hosts/${host}/variables.nix) clock24h;
in
  with lib; {
    # Configure & Theme Waybar
    programs.waybar = {
      enable = true;
      package = pkgs.waybar;
      settings = [
        {
          layer = "top";
          position = "top";
          modules-center = ["hyprland/workspaces"];
          modules-left = [
            "custom/startmenu"
            "hyprland/window"
            "pulseaudio"
            "cpu"
            "memory"
            "disk"
            "network"
            "idle_inhibitor"
          ];
          modules-right = [
            "custom/hyprbindings"
            "custom/notification"
            "tray"
            "custom/weather"
            "clock"
          ];

          "hyprland/workspaces" = {
            format = "{name}";
            format-icons = {
              default = " ";
              active = " ";
              urgent = " ";
            };
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
          };
          "clock" = {
            format =
              if clock24h == true
              then '' {:L%H:%M}''
              else '' {:L%A, %B %d, %Y %I:%M %p}'';
            tooltip = true;
            tooltip-format = "<big>{:%A, %B %d, %Y }</big>\n";
          };
          "hyprland/window" = {
            max-length = 22;
            separate-outputs = false;
            rewrite = {
              "" = " 🙈 No Windows? ";
            };
          };
          "memory" = {
            interval = 5;
            format = " {}%";
            tooltip = true;
          };
          "cpu" = {
            interval = 5;
            format = " {usage:2}%";
            tooltip = true;
          };
          "disk" = {
            format = " {free}";
            tooltip = true;
          };
          "network" = {
            format-icons = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            format-ethernet = " {bandwidthDownOctets}";
            format-wifi = "{icon} {signalStrength}%";
            format-disconnected = "󰤮";
            tooltip = false;
          };
          "tray" = {
            spacing = 12;
          };
          "pulseaudio" = {
            format = "{icon} {volume}% {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = " {volume}%";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [
                ""
                ""
                ""
              ];
            };
            on-click = "sleep 0.1 && pavucontrol";
          };
          "custom/exit" = {
            tooltip = false;
            format = "";
            on-click = "sleep 0.1 && wlogout";
          };
          "custom/startmenu" = {
            tooltip = false;
            format = "";
            # exec = "rofi -show drun";
            on-click = "sleep 0.1 && rofi-launcher";
          };
          "custom/hyprbindings" = {
            tooltip = false;
            format = "󱕴";
            on-click = "sleep 0.1 && list-hypr-bindings";
          };
          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
            tooltip = "true";
          };
          "custom/notification" = {
            tooltip = false;
            format = "{icon} {}";
            format-icons = {
              notification = "<span foreground='red'><sup></sup></span>";
              none = "";
              dnd-notification = "<span foreground='red'><sup></sup></span>";
              dnd-none = "";
              inhibited-notification = "<span foreground='red'><sup></sup></span>";
              inhibited-none = "";
              dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
              dnd-inhibited-none = "";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "sleep 0.1 && task-waybar";
            escape = true;
          };
          "custom/weather" = {
            "format" = "{}°";
            "tooltip" = true;
            "interval" = 3600;
            "exec" = "wttrbar --fahrenheit --mph";
            "return-type" = "json";
          };
          "battery" = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-plugged = "󱘖 {capacity}%";
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            on-click = "";
            tooltip = false;
          };
        }
      ];
      style = concatStrings [
       ''
          * {
              border: none;
              border-radius: 0px;
              font-family: "JetBrainsMono Nerd Font";
              font-weight: bold;
              font-size: 11px;
              min-height: 0;
              transition: 0.3s;
            }

            window#waybar {
                background: rgba(0, 58, 255, 0);
                color: #003AFF;
            }

            tooltip {
                background: #1e1e2e;
                border-radius: 10px;
                border-width: 1.5px;
                border-style: solid;
                border-color: #11111b;
                transition: 0.3s;
            }

            #workspaces button {
                padding: 5px;
                color: #ffffff;
                background: #000000;
                margin-right: 5px;
            }

            #workspaces button.active {
                color: #007FF7;
                background: #000000;
            }

            #workspaces button.focused {
                color: #a6adc8;
                background: #000000;
                border-radius: 20px;
            }

            #workspaces button.urgent {
                color: #11111b;
                background: #000000;
                border-radius: 20px;
            }

            #workspaces button:hover {
                background: #000000;
                color: #cdd6f4;
                border-radius: 20px;
            }

            #custom-power_profile,
            #custom-weather,
            #window,
            #clock,
            #battery,
            #pulseaudio,
            #network,
            #bluetooth,
            #temperature,
            #workspaces,
            #tray,
            #backlight {
                background: #1e1e2e;
                opacity: 0.8;
                padding: 0px 10px;
                margin: 0;
                margin-top: 5px;
                border: 1px solid #181825;
            }

            #temperature {
                border-radius: 20px 0px 0px 20px;
            }

            #temperature.critical {
                color: #eba0ac;
            }

            #backlight {
                border-radius: 20px 0px 0px 20px;
                padding-left: 7px;
            }

            #tray {
                border-radius: 20px;
                margin-right: 5px;
                padding: 0px 4px;
            }

            #workspaces {
                background: #000000;
                border-radius: 20px;
                margin-left: 5px;
                padding-right: 0px;
                padding-left: 5px;
            }

            #custom-power_profile {
                color: #a6e3a1;
                border-left: 0px;
                border-right: 0px;
            }

            #window {
                border-radius: 20px;
                margin-left: 5px;
                margin-right: 5px;
            }

            #clock {
                color: #fab387;
                border-radius: 20px;
                margin-left: 5px;
                border-right: 0px;
                transition: 0.3s;
                padding-left: 7px;
            }

            #network {
                color: #f9e2af;
                border-radius: 20px 0px 0px 20px;
                border-left: 0px;
                border-right: 0px;
            }

            #bluetooth {
                color: #89b4fa;
                border-radius: 20px;
                margin-right: 10px
            } 

            #pulseaudio {
                color: #89b4fa;
                border-left: 0px;
                border-right: 0px;
            }

            #pulseaudio.microphone {
                color: #cba6f7;
                border-left: 0px;
                border-right: 0px;
                border-radius: 0px 20px 20px 0px;
                margin-right: 5px;
                padding-right: 8px;
            }

            #battery {
                color: #a6e3a1;
                border-radius: 0 20px 20px 0;
                margin-right: 5px;
                border-left: 0px;
            }

            #custom-weather {
                border-radius: 20px;
                border-right: 0px;
                margin-left: 0px;
            }
            #custom/startmenu {
              color: #003AFF
              background: #000000
            }
            #hyprland/window {
              color: #003AFF
              background: #000000
            }
      ''
      ];
    };
  }
