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
          height = 1;
          mode = "dock";
          reload_style_on_change = true;
          modules-center = ["hyprland/workspaces"];
          modules-left = [
            "custom/startmenu"
            "hyprland/window"
            "pulseaudio"
            "cpu"
            "memory"
            "disk"
            "disk#disk2"
            "disk#disk3"
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
            format = "<span font='icon'></span>{name}";
            format-icons = {
              default = "Δ ";
              active = "α ";
              urgent = "Ω ";
            };
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
          };
          "clock" = {
            format =
              if clock24h == true
              then '' {:L%H:%M}''
              else ''<span font='icon'></span>  {:L%A, %B %d, %Y %I:%M %p}'';
            tooltip = true;
            tooltip-format = "<big>{:%A, %B %d, %Y }</big>\n";
          };
          "hyprland/window" = {
            max-length = 80;
            separate-outputs = false;
            rewrite = {
              "" = " 🙈 No Windows? ";
            };
          };
          "memory" = {
            interval = 5;
            format = "<span font='icon'></span> {}%";
            tooltip = true;
          };
          "cpu" = {
            interval = 5;
            format = "<span font='icon'></span> {usage:2}%";
            tooltip = true;
          };
          "disk" = {
            format = "<span font='icon'></span> {free}";
            tooltip = true;
            path = "/";
          };
          "disk#disk2" = {
            format = "<span font='icon'></span> {free}";
            tooltip = true;
            path = "/var/plex/movies2";
          };
          "network" = {
            format-icons = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            format-ethernet = "<span font='icon'>↓</span> {bandwidthDownBits} ↑ {bandwidthUpBits}";
            format-wifi = "{icon} {signalStrength}%";
            format-disconnected = "󰤮";
            tooltip = true;
          };
          "tray" = {
            spacing = 12;
          };
          "pulseaudio" = {
            format = "<span font='icon'>{icon}</span> {volume}% {format_source}";
            format-bluetooth = "{volume}% {icon}<span font='icon'></span> {format_source}";
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
            format = "<span font='icon'></span>";
            on-click = "sleep 0.1 && wlogout";
          };
          "custom/startmenu" = {
            tooltip = false;
            format = "<span font='icon'>≡</span>";
            # exec = "rofi -show drun";
            on-click = "sleep 0.1 && rofi-launcher";
          };
          "custom/hyprbindings" = {
            tooltip = false;
            format = "<span font='icon'>♠</span>";
            on-click = "sleep 0.1 && list-hypr-bindings";
          };
          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = "<span font='icon'></span>";
              deactivated = "<span font='icon'></span>";
            };
            tooltip = "true";
          };
          "custom/notification" = {
            tooltip = false;
            format = "<span font='icon'>{icon}</span> {}";
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
            "format" = "<span font='icon'>{}°</span>";
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
                 @import "latte.css";

          * {
            font-family: Star Cine;
            font-size: 14px;
            font-weight: bold;
            min-height: 0;
          }
          #waybar {
            background-color: #003300;
            color: #ffffff;
            margin: 3px 3px;
          }
          #workspaces {
            border-radius: 1rem;
            margin: 5px;
            background-color: #004d00;
            color: #ffffff;
            margin-left: 1rem;
          }
          #workspaces button {
            color: #ffffff;
            border-radius: 1rem;
            padding: 0.4rem;
          }
          #workspaces button.active {
            color: #ffffff;
            background-color: #00b300;
          }
          #workspaces button:hover {
            color: #00FF0C;
          }
          #tray,
          #cpu {
            background-color: #003300;
            padding-right: 5px;
          }
          #memory {
            background-color: #003300;
            padding-right: 5px;
            }
          #disk {
            background-color: #003300;
            padding-right: 5px;
            }
          #network {
            background-color: #003300;
            padding-right: 5px;
            padding-left: 5px;
            }
          #idle_inhibitor {
            background-color: #003300;
              padding-left: 5px;
          }
          #custom-hyprbindings {
            background-color: #003300;
            }
          #custom-notification {
            background-color: #003300;
            padding-left: 10px;
            }
          #clock,
          #pulseaudio {
            background-color: #003300;
            }
          #clock {
            background-color: #003300;
            color: #ffffff;
            margin-left: 5px;
          }
          #pulseaudio {
            background-color: #003300;
            margin-left: 50px;
            padding-right: 5px;
          }
          #tray {
            background-color: #003300;
            padding-right: 10px;
            padding-left: 10px;
          }
          #custom-weather {
              background-color: #003300;
              transition: 0.3s;
              padding-right: 5px;
          }
          #hyprland-window {
              background-color: #003300;
              color: #ffffff;
              transition: 0.3s;
              margin-right: 60px;
              padding: 80px;
          }
          #custom-startmenu {
              background-color: #003300;
              transition: 0.3s;
              border-radius: 20px;
              margin-right: 20px;
          }
        ''
      ];
    };
  }
