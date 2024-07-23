{
  config,
  lib,
  pkgs,
  host,
  username,
  options,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./users.nix
    ./mysql.nix
    ./nginx.nix
    ../../modules/amd-drivers.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
  ];

  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_zen;
    # This is for OBS Virtual Cam Support
    kernelModules = [ "drivetemp"];
    kernelParams = ["reboot=acpi" "coretemp"];
    extraModulePackages = [ ];
    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };

  # Styling Options
  stylix = {
    enable = false;
    image = ../../config/wallpapers/beautifulmountainscape.jpg;
    # base16Scheme = {
    #   base00 = "232136";
    #   base01 = "2a273f";
    #   base02 = "393552";
    #   base03 = "6e6a86";
    #   base04 = "908caa";
    #   base05 = "e0def4";
    #   base06 = "e0def4";
    #   base07 = "56526e";
    #   base08 = "eb6f92";
    #   base09 = "f6c177";
    #   base0A = "ea9a97";
    #   base0B = "3e8fb0";
    #   base0C = "9ccfd8";
    #   base0D = "c4a7e7";
    #   base0E = "f6c177";
    #   base0F = "56526e";
    # };
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };
  # Extra Module Options
  drivers = {
    amdgpu.enable = true;
    nvidia.enable = false;
    nvidia-prime = 
    {
      enable = false;
      intelBusID = "";
      nvidiaBusID = "";
    };
    intel.enable = true;
  };
  vm.guest-services.enable = true;
  local.hardware-clock.enable = false;
  networking = {
  # Enable networking
     nameservers = ["100.100.100.100" "8.8.8.8" "1.1.1.1"];
    search = ["tail20553.ts.net"];
    firewall = {
      enable = true;
      allowedTCPPorts = [21 57796 80 443 8181 3306 8000 8095 8123 1220 6969 8081 26648 9090 8080 3389 51820 51827 32400 5901 5938 8581 43148 8888 23421 50707 51578 5580];
      allowedTCPPortRanges = [
        {
          from = 20000;
          to = 28000;
        }
        {
          from = 51000;
          to = 59000;
        }
      ];
      allowedUDPPorts = [1900 1901 137 136 138 41641 3478 21063 5353];
      trustedInterfaces = ["tailscale0"];
    };
    networkmanager.enable = true;
    enableIPv6 = true;
    hostName = host;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
  };
  # Set your time zone.
  time.timeZone = "America/Chicago";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

  programs = {
        git = {
      enable = true;
      #  userName = "derekagraham78";
      #  userEmail = "derekagraham78@icloud.com";
    };
    zsh = {
      enable = false;
      # Your zsh config
      ohMyZsh = {
        enable = true;
        plugins = ["git" "python" "man" "1password"];
        theme = "aussiegeek";
      };
    };
    xfconf.enable = true;  
    hyprland.enable = true;
    xwayland.enable = true;
    firefox.enable = true;
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        buf = {
          symbol = " ";
        };
        c = {
          symbol = " ";
        };
        directory = {
          read_only = " 󰌾";
        };
        docker_context = {
          symbol = " ";
        };
        fossil_branch = {
          symbol = " ";
        };
        git_branch = {
          symbol = " ";
        };
        golang = {
          symbol = " ";
        };
        hg_branch = {
          symbol = " ";
        };
        hostname = {
          ssh_symbol = " ";
        };
        lua = {
          symbol = " ";
        };
        memory_usage = {
          symbol = "󰍛 ";
        };
        meson = {
          symbol = "󰔷 ";
        };
        nim = {
          symbol = "󰆥 ";
        };
        nix_shell = {
          symbol = " ";
        };
        nodejs = {
          symbol = " ";
        };
        ocaml = {
          symbol = " ";
        };
        package = {
          symbol = "󰏗 ";
        };
        python = {
          symbol = " ";
        };
        rust = {
          symbol = " ";
        };
        swift = {
          symbol = " ";
        };
        zig = {
          symbol = " ";
        };
      };
    };
    dconf.enable = true;
    seahorse.enable = false;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    thunar = {
      enable = false;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
};
systemd = {  
  services = {
    ownership = {
      path = [pkgs.zsh];
      serviceConfig = {
        ExecStart = "/root/bin/ownership-update";
        Type = "oneshot";
        User = "root";
      };
    };
    backupmyconfs = {
      path = [pkgs.zsh];
      serviceConfig = {
        ExecStart = "/home/dgraham/bin/check4update";
        Type = "oneshot";
        User = "dgraham";
      };
    };
    flatpak-repo = {
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
    };
  };
  timers = {
    ownership = {
      timerConfig = {
        OnBootSec = "15m";
        OnUnitActiveSec = "15m";
        Unit = "ownership.service";
      };
    };
    backupmyconfs = {
      timerConfig = {
        OnBootSec = "60m";
        OnUnitActiveSec = "60m";
        Unit = "backupmyconfs.service";
      };
    };
  };
}; 
system = {
  autoUpgrade = {
    enable = true;
    flake = "github:derekagraham78/nixos/flake.nix";
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };
};
nixpkgs.config.allowUnfree = true;
users = {
    mutableUsers = true;
};
environment.systemPackages = with pkgs; [
    pkgs.kdePackages.gwenview
    pkgs.sway
    pkgs.swaylock-effects
    pkgs.swayidle
    starship    
    wttrbar 
    vscode-with-extensions
    element-desktop
    vivaldi
    floorp
    vivaldi-ffmpeg-codecs
	  aspell
    nanorc
    variety
    wget
    killall
    eza
    git
    cmatrix
    fastfetch
    htop
    atop
    libvirt
    lxqt.lxqt-policykit
    lm_sensors
    unzip
    unrar
    libnotify
    ydotool
    duf
    ncdu
    wl-clipboard
    pciutils
    ffmpeg
    socat
    ripgrep
    lshw
    bat
    pkg-config
    meson
    hyprpicker
    ninja
    brightnessctl
    virt-viewer
    swappy
    appimage-run
    yad
    inxi
    playerctl
    nh
    nixfmt-rfc-style
    discord
    pkgs.betterdiscordctl
    libvirt
    grim
    slurp
    file-roller
    swww
    waypaper
    swaynotificationcenter
    imv
    mpv
    gimp
    tree
    spotify
    neovide
    greetd.gtkgreet
    filezilla
    imagemagick
    cockpit
    gnome-disk-utility
    whois
    docker-compose
    deadnix
    slack
    cachix
    statix
    wev
    w3m
    deluge-gtk
    sushi
    clipmenu
    emojipick
    noisetorch
    gh
    libsixel
    file
    hddtemp
    ipmitool
    mdadm
    smartmontools
    glxinfo
    wmctrl
    usbutils
    zip
    xz
    p7zip
    # utils
    jq # A lightweight and flexible command-li>
    # networking tools
    networkmanager
    networkmanager-openvpn
    networkmanager_dmenu
    networkmanagerapplet
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide th>
    aria2 # A lightweight multi-protocol & mul>
    nmap # A utility for network discovery and>
    ipcalc # it is a calculator for the IPv4/>
    # misc
    alejandra
    php
    file
    which
    gnused
    gnutar
    gawk
    zstd
    gnupg
    # it provides the command `nom` works just lik>
    # with more details log output
    nix-output-monitor
    # productivity
    glow # markdown previewer in terminal
    iotop # io monitoring
    iftop # network monitoring
    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files
    # system tools
    inotify-tools
    sysstat
    ethtool
    webp-pixbuf-loader
    poppler
    ffmpegthumbnailer
    evince
    digikam
    _1password-gui-beta
    _1password
    fmt
    telegram-desktop
    nodejs_latest
    kitty
    kitty-img
    kitty-themes
    yarn2nix
    yarn
    qt6.qt5compat
    pkgs.qt6.full
    libsForQt5.full
    pkgs.nodePackages_latest.pnpm
    freetype
    fontconfig
    gnumake
    gcc13
    rPackages.trekfont
    pkgs.gnome-system-monitor
    pkgs.gnome.nautilus
    pkgs.gnome.sushi
    pkgs.swappy
    pkgs.grimblast
  ];
  fonts.packages = with pkgs; [
    noto-fonts-emoji
    noto-fonts-cjk
    font-awesome
    symbola
    rPackages.trekfont
    noto-fonts
    noto-fonts-cjk
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
    terminus-nerdfont
    udev-gothic-nf
    powerline-fonts
    noto-fonts-emoji
    liberation_ttf
    fira-code
    material-icons
    nginx
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];
  console = {
    earlySetup = true;
    packages = with pkgs; [
      nerdfonts
      terminus_font
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
      terminus-nerdfont
    ];
    keyMap = "us";
  };
  environment.variables = {
    ZANEYOS_VERSION = "2.2";
    ZANEYOS = "true";
  };
# Extra Portal Configuration
xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
};

# Services to start
services = {
  emacs = {
    enable = false;
    package = pkgs.emacs;
  };
  resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
    fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
    dnsovertls = "true";
  };
  tailscale = {
    enable = true;
  };
  vsftpd = {
    enable = true;
    writeEnable = true;
    localUsers = true;
    userlist = ["dgraham" "root" "nginx"];
    userlistEnable = true;
    virtualUseLocalPrivs = true;
  };
  memcached.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  certmgr.renewInterval = "30m";
  cockpit = {
      enable = true;
      port = 9090;
      settings = {
        WebService = {
          Origins = "https://www.papalpenguin.com:9090 https://papalpenguin.com:9090 http://www.papalpenguin.com:9090 http://papalpenguin.com:9090 https://192.168.4.60:9090 http://192.168.4.60:9090 ws://192.168.4.60:9090 ws://papalpenguin.com:9090 ws://www.papalpenguin.com:9090 http://mulder.tail20553.ts.net:9090 https://mulder.tail20553.ts.net:9090";
          ProtocolHeader = "X-Forwarded-Proto";
          ForwardedForHeader = "X-Forwarded-For";
          AllowUnencrypted = true;
        };
      };
  };
  openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PermitRootLogin = "yes";
      AllowGroups = ["wheel" "root"];
    };
    allowSFTP = true;
  };
  fwupd.enable = true;
  xrdp.enable = false;
  plex = {
    enable = true;
    openFirewall = true;
  };
  xserver = {
    enable = false;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  greetd = {
    enable = true;
    vt = 12;
    settings = rec {
      initial_session = { command = "Hyprland"; user = "dgraham"; };
      default_session = initial_session;
      #{
      # Wayland Desktop Manager is installed only for user ryan via home-manager!
      # user = "dgraham";
      # .wayland-session is a script generated by home-manager, which links to the current wayland compositor(sway/hyprland or others).
      # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config here.
      # command = "$HOME/.wayland-session"; # start a wayland session directly without a login manager
      # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland"; # start Hyprland with a TUI login manager
      #};
    };
  };
  smartd = {
    enable = false;
    autodetect = true;
  };
  libinput.enable = true;
  fstrim.enable = true;
  gvfs.enable = true;
  flatpak.enable = true;
  printing = {
    enable = true;
    drivers = [
    pkgs.brlaser
    ];
  };
  gnome.gnome-keyring.enable = true;
  ipp-usb.enable = true;
  syncthing = {
    enable = false;
    user = "${username}";
    dataDir = "/home/${username}";
    configDir = "/home/${username}/.config/syncthing";
  };
  pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  rpcbind.enable = false;
  nfs.server.enable = false;
};
hardware = {
  sane = {
    enable = true;
    extraBackends = [pkgs.sane-airscan];
    disabledDefaultBackends = ["escl"];
  };
# Extra Logitech Support
  logitech.wireless = { 
    enable = true;
    enableGraphical = true;
  };
# Bluetooth Support
  bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
# Enable sound with pipewire.
# sound.enable = true;
  pulseaudio.enable = false;
  graphics = {
    enable = true;
  };
};
# Security / Polkit
security = 
  {
    doas = {
      enable = true;
      wheelNeedsPassword = false;
    };
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
    acme = {
      acceptTerms = true;
      defaults.email = "derek@papalpenguin.com";
      defaults.renewInterval = "daily";
    };
    rtkit.enable = true;
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
              action.id == "org.freedesktop.login1.reboot" ||
              action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
              action.id == "org.freedesktop.login1.power-off" ||
              action.id == "org.freedesktop.login1.power-off-multiple-sessions"
            )
        )
      {
        return polkit.Result.YES;
      }
    })
    '';
    };
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
 };
# Optimization settings and garbage collection automation
nix = {
  settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
  gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };
};
# Virtualization / Containers
virtualisation = {
  libvirtd.enable = true;
  podman = {
    enable = true;
    #dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  docker.enable = true;
};
  # This value determines the OS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
