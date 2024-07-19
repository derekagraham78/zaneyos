# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
  ];
  programs = {
    git = {
      enable = true;
      #  userName = "derekagraham78";
      #  userEmail = "derekagraham78@icloud.com";
    };
    zsh = {
      enable = true;
      # Your zsh config
      ohMyZsh = {
        enable = true;
        plugins = ["git" "python" "man" "1password"];
        theme = "aussiegeek";
      };
    };
    xfconf.enable = true;
  };
  virtualisation.docker.enable = true;
  systemd.services.ownership = {
    path = [pkgs.zsh];
    serviceConfig = {
      ExecStart = "/root/bin/ownership-update";
      wantedBy = ["default.target"];
      Type = "oneshot";
      User = "root";
    };
  };
  systemd.timers.ownership = {
    timerConfig = {
      OnBootSec = "15m";
      OnUnitActiveSec = "15m";
      Unit = "ownership.service";
    };
  };

  systemd.services.backupmyconfs = {
    path = [pkgs.zsh];
    serviceConfig = {
      ExecStart = "/home/dgraham/bin/check4update";
      wantedBy = ["default.target"];
      Type = "oneshot";
      User = "dgraham";
    };
  };
  systemd.timers.backupmyconfs = {
    timerConfig = {
      OnBootSec = "60m";
      OnUnitActiveSec = "60m";
      Unit = "backupmyconfs.service";
    };
  };
  system.autoUpgrade = {
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
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    emacs
    helix
    filezilla
    imagemagick
    cockpit
    gnome-disk-utility
    gparted
    whois
    docker-compose
    eza
    deadnix
    slack
    cachix
    statix
    wev
    w3m
    deluge-gtk
    nautilus
    nautilus-open-any-terminal
    sushi
    gwenview
    clipmenu
    emojipick
    wev
    killall
    grim #screes capture
    slurp
    noisetorch
    git
    wget
    gh
    libsixel
    file
    hddtemp
    ipmitool
    mdadm
    smartmontools
    tree
    glxinfo
    wmctrl
    xorg.xdpyinfo
    usbutils
    zip
    xz
    unzip
    p7zip
    # utils
    ripgrep # recursively searches directories>
    jq # A lightweight and flexible command-li>
    # networking tools
    networkmanager
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide th>
    aria2 # A lightweight multi-protocol & mul>
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and>
    ipcalc # it is a calculator for the IPv4/>
    # misc
    alejandra
    php
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    # nix related
    #
    # it provides the command `nom` works just lik>
    # with more details log output
    nix-output-monitor
    # productivity
    glow # markdown previewer in terminal
    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files
    # system tools
    inotify-tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    gh
    webp-pixbuf-loader
    poppler
    ffmpegthumbnailer
    evince
    stacer
    digikam
    _1password-gui
    cpu-x
    wireshark
    vim
    fmt
    telegram-desktop
    discord
    vlc
    nodejs_latest
    kitty
    kitty-img
    kitty-themes
    yarn2nix
    yarn
    moc
    qt6.qt5compat
    pkgs.qt6.full
    libsForQt5.full
    xorg.xcbutil
    pkgs.nodePackages_latest.pnpm
    pkgs.usbutils
    freetype
    fontconfig
    gnumake
    gcc13
    resilio-sync
    fmt
    pciutils
    geekbench
    inxi
    rPackages.trekfont
  ];

  #  system.stateVersion = "unstable-small"; # Did you read the comment?
}
