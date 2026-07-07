# packages.nix
{pkgs, ...}: {

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
    syncthing.enable = false;
  };

  # ============================================================
  # PACKAGES
  # ============================================================

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "ventoy-1.1.12" "electron-39.8.10" ];

  environment.systemPackages = with pkgs; [
    # --- editors & lsp ---
    helix
    nil                          # nix lsp
    vscode-langservers-extracted # html/css/json lsp
    lua-language-server
    hyprls

    # --- terminal & shell utils ---
    btop
    mpv
    fzf
    fd
    jq
    curl
    tldr
    navi
    microfetch
    cmatrix
    lazygit
    git
    gh
    python3
    nh
    nixmate
    ventoy
    yazi
    kitty
    systemctl-tui
    yewtube

    # --- desktop & theming ---
    swayfx
    noctalia-shell #v4
    nwg-look
    noctalia-qs
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
    xdelta    

    # --- media ---
    vlc
    gimp
    obs-studio
    kdePackages.kdenlive
    rmpc
    #(ytm-player.overrideAttrs { doCheck = false; })
    youtube-tui

    # --- apps ---
    # obsidian
    qbittorrent
    nicotine-plus
    proton-vpn
    protonmail-desktop
    localsend
    easyrpg-player
    legcord
    equibop

    # --- sway utils ---
    autotiling
    satty
    trayscale

    # --- hardware & connectivity ---
    android-tools
    scrcpy
    upower
    power-profiles-daemon
    mission-center

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
      "dev.vencord.Vesktop"
      "io.itch.itch"
      "com.heroicgameslauncher.hgl"
      "hu.kramo.Cartridges"
    ];
  };






  
}
