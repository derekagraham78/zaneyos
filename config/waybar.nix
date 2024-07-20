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
       @import "latte.css";

* {
  font-family: FantasqueSansMono Nerd Font;
  font-size: 17px;
  min-height: 0;
}

#waybar {
  background: transparent;
  color: @text;
  margin: 5px 5px;
}

#workspaces {
  border-radius: 1rem;
  margin: 5px;
  background-color: @surface0;
  margin-left: 1rem;
}

#workspaces button {
  color: @lavender;
  border-radius: 1rem;
  padding: 0.4rem;
}

#workspaces button.active {
  color: @sky;
  border-radius: 1rem;
}

#workspaces button:hover {
  color: @sapphire;
  border-radius: 1rem;
}

#custom-music,
#tray,
#cpu {
  background-color: @surface0;
}
#memory {
  background-color: @surface0;
  }
#disk {
  background-color: @surface0;
  }
#network {
  background-color: @surface0;
  }
#idle_inhibitor {
  background-color: @surface0;
}
#custom-hyprbindings {
  background-color: @surface0;
  border-radius: 20px;
  margin-right: 1rem;
  }
#custom-notification {
  background-color: #000000;
  border-radius: 20px;
  padding-left: 10px;
  margin-left: 30px;
  margin-right: 30px;
  padding-right: 10px;
  }
#backlight,
#clock,
#battery,
#pulseaudio {
  background-color: @surface0;
  }
#custom-lock,
#custom-power {
  background-color: @surface0;
  padding: 0.5rem 1rem;
  margin: 5px 0;
}

#clock {
  color: @blue;
  border-radius: 0px 1rem 1rem 0px;
  margin-right: 1rem;
}

#battery {
  color: @green;
}

#battery.charging {
  color: @green;
}

#battery.warning:not(.charging) {
  color: @red;
}

#backlight {
  color: @yellow;
}

#backlight, #battery {
    border-radius: 0;
}

#pulseaudio {
  color: @maroon;
}

#custom-music {
  color: @mauve;
  border-radius: 1rem;
}

#custom-lock {
    border-radius: 1rem 0px 0px 1rem;
    color: @lavender;
}

#custom-power {
    margin-right: 1rem;
    border-radius: 0px 1rem 1rem 0px;
    color: @red;
}

#tray {
  margin-right: 1rem;
  border-radius: 90px;
}

#custom-weather {
    background-color: @surface0;
    border-radius: 20px;
    margin-left: 5px;
    border-right: 0px;
    transition: 0.3s;
    padding-left: 7px;  
    border-radius: 20px;
}
#hyprland-window {
    background-color: @surface0;
    transition: 0.3s;
    border-radius: 20px;
}
#custom-startmenu {
    background-color: @surface0;
    transition: 0.3s;
    border-radius: 20px;
    padding: 8px;
}
      ''
      ];
    };
  }
