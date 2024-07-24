{
  lib,
  username,
  host,
  inputs,
  pkgs,
  config,
  ...
}: let
  hyprplugins = inputs.hyprland-plugins.packages.${pkgs.system};
  inherit
    (import ../hosts/${host}/variables.nix)
    browser
    terminal
    extraMonitorSettings
    ;
in
  with lib; {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      plugins = [
        pkgs.hyprlandPlugins.hyprbars
        pkgs.hyprlandPlugins.hyprexpo
        #pkgs.hyprlandPlugins.hyprtrails
      ];
      extraConfig = let
        modifier = "SUPER";
      in
        concatStrings [
          ''
            # Environment Variables
            env = NIXPKGS_ALLOW_UNFREE,1
            env = NIXOS_OZONE_WL,1
            env = QT_AUTO_SCREEN_SCALE_FACTOR,1
            env = XDG_CURRENT_DESKTOP,Hyprland
            env = ELECTRON_OZONE_PLATFORM_HINT,auto
            env = XDG_SESSION_TYPE,wayland
            env = XDG_SESSION_DESKTOP,Hyprland
            env = GDK_BACKEND,wayland,x11,*
            env = QT_QPA_PLATFORMTHEME,qt5ct
            env = CLUTTER_BACKEND,wayland
            env = QT_QPA_PLATFORM,wayland;xcb
            env = XCURSOR_SIZE,32
            env = SDL_VIDEODRIVER,wayland
            env = MOZ_ENABLE_WAYLAND,1
            # Startup Apps
            exec-once = swww-daemon --format xrgb
            exec-once = swayidle -C ~/.config/swayidle/idle.conf
            exec-once = variety
            exec-once = dbus-update-activation-environment --systemd --all
            exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
            exec-once = killall -q swww;sleep .5 && swww init
            exec-once = waybar
            exec-once = killall -q swaync;sleep .5 && swaync
            exec-once = nm-applet --indicator
            exec-once = lxqt-policykit-agent
            # Monitor Setup
            monitor=HDMI-A-3, 1920x1080, auto-left, 1
            monitor=HDMI-A-1, 1920x1080, auto-right, 1
            xwayland {
                force_zero_scaling = false;
                     }
            # toolkit-specific scale
            # env = GDK_SCALE,1
            # Workspace Configuration
            workspace = name:1-Web,monitor:HDMI-A-3,default:true,persistant:true
            workspace = name:2-Terms,monitor:HDMI-A-3,default:true,persistant:true
            workspace = name:3-Files,monitor:HDMI-A-3,default:true,persistant:true
            workspace = name:4-Editors,monitor:HDMI-A-3,default:true,persistant:true
            workspace = name:Desktop,monitor:HDMI-A-3,default:true,persistant:true
            workspace = name:Desktop2,monitor:HDMI-A-1,default:true,persistant:true
            workspace = name:6-Chat,monitor:HDMI-A-1,default:true,persistant:true
            workspace = name:7-Misc,monitor:HDMI-A-1,default:true,persistant:true
            #workspace = 8,monitor:HDMI-A-1,default:true,persistant:true
            #workspace = 9,monitor:HDMI-A-1,default:true,persistant:true
            #workspace = 10,monitor:HDMI-A-1,default:true,persistant:true
            ${extraMonitorSettings}
            # General Settings
            general {
            gaps_in = 1
            gaps_out = 1
            border_size = 10
            no_border_on_floating = true
            layout = dwindle
            resize_on_border = true
            col.active_border = rgb(${config.stylix.base16Scheme.base08}) rgb(${config.stylix.base16Scheme.base0C}) 45deg
            col.inactive_border = rgb(${config.stylix.base16Scheme.base01})
            }
            # Grouped Apps
            group {
              groupbar {
                stacked = false
                font_family = Star Cine
                font_size = 10
                height = 20
                text_color = rgb(ffffff)
                col.active = rgb(25f20f)
                col.inactive = rgb(009900)
                col.locked_active = rgb(25f20f)
                col.locked_inactive = rgb(009900)
              }
            }
            # Inputs
            input {
            kb_layout = us
            kb_options = grp:alt_shift_toggle
            kb_options = caps:super
            numlock_by_default = true
            follow_mouse = 1
            touchpad {
            natural_scroll = false
            }
            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
            accel_profile = flat
            }
            $grouped-apps = Signal|discord|Element|org.telegram.desktop
            # Some Rules for Windows
            windowrule = noborder,^(wofi)$
            windowrule = center,^(wofi)$
            windowrule = center,^(steam)$
            windowrule = float, nm-connection-editor|blueman-manager
            windowrule = float, swayimg|vlc|Viewnior|pavucontrol
            windowrule = float, nwg-look|qt5ct|mpv
            windowrule = float, zoom
            windowrulev2 = group set always lock invade, class:^($grouped-apps)$
            windowrulev2 = stayfocused, title:^()$,class:^(steam)$
            windowrulev2 = float,class:^(1Password)$
            windowrulev2 = pin,class:^(1Password)$
            windowrulev2 = center 1,class:^(1Password)$
            windowrulev2 = size 20% 40%,class:^(1Password)$
            windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$
            windowrulev2 = opacity 0.9 0.7, class:^(Brave)$
            windowrulev2 = opacity 1.0 1.0, class:^(org.gnome.Nautilus)$
            #windowrulev2 = nomaximizerequest, class:.* # You'll probably like this.
            windowrulev2 = workspace name:7-Misc, class:^(deluge)$
            windowrulev2 = workspace name:7-Misc, class:^(floorp)$
            windowrulev2 = workspace name:6-Chat, class:^(discord)$
            windowrulev2 = workspace name:6-Chat, class:^(Element)$
            windowrulev2 = workspace name:6-Chat, class:^(Signal)$
            windowrulev2 = maxsize 25 25, class:^(Signal)$
            windowrulev2 = workspace name:6-Chat, class:^(org.telegram.desktop)$
            windowrulev2 = workspace name:1-Web, class:^(Vivaldi-stable)$
            windowrulev2 = workspace name:4-Editors, class:^(Code)$
            windowrulev2 = workspace name:3-Files, class:^(org.gnome.Nautilus)$
            windowrulev2 = workspace name:2-Terms, class:^(kitty)$
            windowrulev2 = float,class:^(org.gnome.SystemMonitor)$
            windowrulev2 = size 20% 40%,class:^(org.gnome.SystemMonitor)$
            # Open up my regular apps
            exec-once = org.signal.Signal
            exec-once = telegram-desktop
            exec-once = discord
            exec-once = element-desktop
            exec-once = gnome-system-monitor
            gestures {
            workspace_swipe = true
            workspace_swipe_fingers   = 3
            }
            # Misc
            misc {
              initial_workspace_tracking = 0
              vrr = 0
              mouse_move_enables_dpms = true
              key_press_enables_dpms = false
            }
            # Animations
            animations {
            enabled = yes
            bezier = wind, 0.05, 0.9, 0.1, 1.05
            bezier = winIn, 0.1, 1.1, 0.1, 1.1
            bezier = winOut, 0.3, -0.3, 0, 1
            bezier = liner, 1, 1, 1, 1
            animation = windows, 1, 6, wind, slide
            animation = windowsIn, 1, 6, winIn, slide
            animation = windowsOut, 1, 5, winOut, slide
            animation = windowsMove, 1, 5, wind, slide
            animation = border, 1, 1, liner
            animation = fade, 1, 10, default
            animation = workspaces, 1, 5, wind
            }
            # Decorations
            decoration {
            rounding = 30
            drop_shadow = true
            shadow_range = 8
            inactive_opacity = 0.8 #0.4
            active_opacity = 1.0
            fullscreen_opacity = 1.0
            shadow_render_power = 3
            col.shadow = rgba(1a1a1aee)
            blur {
            enabled = false
            size = 5
            passes = 4
            new_optimizations = on
            ignore_opacity = on
            }
            }
            # Plugins
            plugin {
                #hyprtrails {
                #    color = rgba(ffaa00ff)
                #}
                hyprexpo {
                    columns = 3
                    gap_size = 5
                    bg_col = rgb(111111)
                    workspace_method = center current # [center/first] [workspace] e.g. first 1 or center m+1

                    enable_gesture = false # laptop touchpad
                    #gesture_fingers = 3  # 3 or 4
                    #gesture_distance = 300 # how far is the "max"
                    #gesture_positive = true # positive = swipe down. Negative = swipe up.
                }
                hyprbars {
                    bar_height = 25
                    bar_color = rgb(003300)
                    col.text = rgb(ffffff)
                    bar_text_font = Star Cine
                    bar_text_size = 16
                    bar_part_of_window = false
                    # example buttons (R -> L)
                    # hyprbars-button = color, size, on-click
                    #hyprbars-button = rgb(E9C7FF), 10, 󰖭, hyprctl dispatch killactive
                    #hyprbars-button = rgb(BD0BAA), 10, , hyprctl dispatch fullscreen 1
                    }
            }
            dwindle {
            pseudotile = true
            preserve_split = true
            }
            debug {
                disable_logs = true
                }
            # Binds
            bind = ${modifier},Return,exec,${terminal}
            bind = ${modifier}SHIFT,Return,exec,rofi-launcher
            bind = ${modifier}SHIFT,W,exec,web-search
            bind = ${modifier}CONTROL,W,exec,waybar
            bind = ${modifier}ALT,W,exec,variety
            bind = ,PRINT,exec,grimblast save screen -| swappy -f -
            bind = ${modifier},PRINT,exec,grimblast save output -| swappy -f -
            bind = ${modifier}CONTROL,PRINT,exec,grimblast save area -| swappy -f -
            bind = ${modifier}SHIFT,N,exec,swaync-client -rs
            bind = ${modifier},W,exec,${browser}
            bind = ${modifier},V,exec, code
            bind = ${modifier},Z, hyprexpo:expo,toggle
            bind = ${modifier},N,exec, nautilus
            bind = ${modifier},E,exec,emopicker9000
            bind = ${modifier},D,exec,discord
            bind = ${modifier},O,exec,obs
            bind = ${modifier}CONTROL,1,exec,1password
            bind = ${modifier}CONTROL,2,exec,swayidle -C ~/.config/swayidle/idle.conf
            bind = ${modifier}CONTROL,C,exec,hyprpicker -a
            bind = ${modifier},C,exec,~/bin/chat.sh
            bind = ${modifier},G,exec,gimp
            bind = ${modifier}SHIFT,G,exec,godot4
            bind = ${modifier},T,exec,gnome-system-monitor
            bind = ${modifier},M,exec,spotify
            bind = ${modifier},Q,killactive,
            bind = ${modifier},P,pseudo,
            bind = ${modifier}SHIFT,I,togglesplit,
            bind = ${modifier},F,fullscreen,
            bind = ${modifier}SHIFT,F,togglefloating,
            bind = ${modifier}SHIFT,C,exit,
            bind = ${modifier}SHIFT,left,movewindow,l
            bind = ${modifier}SHIFT,right,movewindow,r
            bind = ${modifier}SHIFT,up,movewindow,u
            bind = ${modifier}SHIFT,down,movewindow,d
            bind = ${modifier}SHIFT,h,movewindow,l
            bind = ${modifier}SHIFT,l,movewindow,r
            bind = ${modifier}SHIFT,k,movewindow,u
            bind = ${modifier}SHIFT,j,movewindow,d
            bind = ${modifier},left,movefocus,l
            bind = ${modifier},right,movefocus,r
            bind = ${modifier},up,movefocus,u
            bind = ${modifier},down,movefocus,d
            bind = ${modifier},h,movefocus,l
            bind = ${modifier},l,exec,swaylock -C ~/.config/swaylock/lock.conf
            #movefocus,r
            bind = ${modifier},k,movefocus,u
            bind = ${modifier},j,movefocus,d
            bind = ${modifier},1,workspace,name:1-Web
            bind = ${modifier},2,workspace,name:2-Terms
            bind = ${modifier},3,workspace,name:3-Files
            bind = ${modifier},4,workspace,name:4-Editors
            bind = ${modifier},5,workspace,5
            bind = ${modifier},6,workspace,name:6-Chat
            bind = ${modifier},7,workspace,name:7-Misc
            bind = ${modifier},8,workspace,8
            bind = ${modifier},9,workspace,9
            bind = ${modifier},0,workspace,10
            bind = ${modifier}SHIFT,D, workspace,name:Desktop
            bind = ${modifier},D, workspace,name:Desktop2
            bind = ${modifier}SHIFT,SPACE,movetoworkspace,special
            bind = ${modifier},SPACE,togglespecialworkspace
            bind = ${modifier}SHIFT,1,movetoworkspace,name:1-Web
            bind = ${modifier}SHIFT,2,movetoworkspace,name:2-Terms
            bind = ${modifier}SHIFT,3,movetoworkspace,name:3-Files
            bind = ${modifier}SHIFT,4,movetoworkspace,name:4-Editors
            bind = ${modifier}SHIFT,5,movetoworkspace,5
            bind = ${modifier}SHIFT,6,movetoworkspace,name:6-Chat
            bind = ${modifier}SHIFT,7,movetoworkspace,name:7-Misc
            bind = ${modifier}SHIFT,8,movetoworkspace,8
            bind = ${modifier}SHIFT,9,movetoworkspace,9
            bind = ${modifier}SHIFT,0,movetoworkspace,10
            bind = ${modifier}CONTROL,right,workspace,e+1
            bind = ${modifier}CONTROL,left,workspace,e-1
            bind = ${modifier},mouse_down,workspace, e+1
            bind = ${modifier},mouse_up,workspace, e-1
            bindm = ${modifier},mouse:272,movewindow
            bindm = ${modifier},mouse:273,resizewindow
            bind = ALT,Tab,cyclenext
            bind = ALT,Tab,bringactivetotop
            bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
            bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
            binde = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
            bind = ,XF86AudioPlay, exec, playerctl play-pause
            bind = ,XF86AudioPause, exec, playerctl play-pause
            bind = ,XF86AudioNext, exec, playerctl next
            bind = ,XF86AudioPrev, exec, playerctl previous
            bind = ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
            bind = ,XF86MonBrightnessUp,exec,brightnessctl set +5%
          ''
        ];
    };
  }
