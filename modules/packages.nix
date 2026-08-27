# packages.nix
{ pkgs, ... }: {

  # ============================================================
  # PROGRAMS & SERVICES
  # ============================================================

  programs = {
    steam.enable = true;
    fish.enable = true;
    kdeconnect.enable = true;
    dconf.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        zlib
        stdenv.cc.cc
        openssl
        alsa-lib
        libopus
      ];
    };
  };

  services = {
    blueman.enable = true;
    upower.enable = true;
    gvfs.enable = true;
    tuned.enable = true;
    logind.settings.Login.HandleLidSwitch = "ignore";
    usbmuxd.enable = false;
  };

  # ============================================================
  # PACKAGES
  # ============================================================

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];

  environment.systemPackages = with pkgs; [
    # --- editors & lsp ---
    helix
    nixd # nix lsp
    vscode-langservers-extracted # html/css/json lsp
    taplo
    fish-lsp
    marksman

    # --- terminal & shell utils ---
    btop
    fzf
    curl
    microfetch
    cmatrix
    lazygit
    git
    python3
    gh
    nh
    yazi
    kitty
    yewtube

    # --- desktop & theming ---
    swayfx
    vicinae
    #noctalia-shell #v4
    nwg-look
    #noctalia-qs
    adw-gtk3
    gtk3
    glib
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    desktop-file-utils

    # --- files & drives ---
    nemo
    tree
    file-roller
    gparted
    udisks2
    udiskie
    exfatprogs
    aria2

    # --- media ---
    vlc
    gimp
    obs-studio
    #kdePackages.kdenlive
    rmpc
    youtube-tui

    # --- apps ---
    qbittorrent
    proton-vpn
    localsend
    syncthing
    equibop
    concord
    epiphany
    # bitwarden-desktop

    # --- sway utils ---
    autotiling

    # --- hardware & connectivity ---
    android-tools
    scrcpy
    upower
    power-profiles-daemon
    #mission-center

    # --- print/scan ---
    system-config-printer
    simple-scan
  ];

  # flatpak packages (managed declaratively via nix-flatpak)
  services.flatpak = {
    enable = true;
    packages = [
      "net.waterfox.waterfox"
      "org.freedownloadmanager.Manager"
      "me.timschneeberger.GalaxyBudsClient"
      "org.onlyoffice.desktopeditors"
    ];
  };
}
