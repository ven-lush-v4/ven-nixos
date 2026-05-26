{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ];


  # ============================================================
  # NIX & HOME MANAGER
  # ============================================================

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    trusted-users = [ "root" "ven" ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://attic.xuyh0120.win/lantian"
      "https://cache.garnix.io"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  home-manager = {
    users.ven = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };


  # ============================================================
  # BOOT & KERNEL
  # ============================================================

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 10;
    efi.canTouchEfiVariables = true;
  };

  # cachyos kernel - swap comment to use base linux kernel instead
  boot.kernelPackages = pkgs.cachyosKernels."linuxPackages-cachyos-latest";
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [ "quiet" "splash" "udev.log_priority=3" ];
  boot.kernel.sysctl."vm.swappiness" = 10;
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.initrd.systemd.enable = false;

  boot.plymouth = {
    enable = true;
    theme = "dna";
    themePackages = with pkgs; [
      (adi1090x-plymouth-themes.override {
        selected_themes = [ "dna" ];
      })
    ];
  };

  # autologin (no display manager)
  services.getty.autologinUser = "ven";
  # services.displayManager.ly = {
  #   enable = true;
  #   settings = {
  #     animation = "matrix";
  #     vi_mode = false;
  #     default_enviroment = "hyprland";
  #   };
  # };


  # ============================================================
  # HARDWARE
  # ============================================================

  swapDevices = [];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      mesa
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;


  # ============================================================
  # NETWORKING
  # ============================================================

  networking.hostName = "ven-nixos";
  networking.networkmanager.enable = true;

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };


  # ============================================================
  # DESKTOP / DISPLAY
  # ============================================================

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  # suppress kded6 autostart (not needed on hyprland)
  environment.etc."xdg/autostart/kded6.desktop".source = "/dev/null";
  environment.pathsToLink = [ "/share/gsettings-schemas" "/share/glib-2.0" ];


  # ============================================================
  # AUDIO
  # ============================================================

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  # ============================================================
  # LOCALE & INPUT
  # ============================================================

  time.timeZone = "Europe/Dublin";

  i18n.defaultLocale = "en_IE.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT    = "en_IE.UTF-8";
    LC_MONETARY       = "en_IE.UTF-8";
    LC_NAME           = "en_IE.UTF-8";
    LC_NUMERIC        = "en_IE.UTF-8";
    LC_PAPER          = "en_IE.UTF-8";
    LC_TELEPHONE      = "en_IE.UTF-8";
    LC_TIME           = "en_IE.UTF-8";
  };

  console.keyMap = "uk";

  services.xserver.xkb = {
    layout = "gb";
    variant = "gla";
  };


  # ============================================================
  # USERS
  # ============================================================

  users.users.ven = {
    isNormalUser = true;
    description = "ven";
    extraGroups = [ "networkmanager" "wheel" "adbusers" "scanner" "lp" ];
    packages = [];
    shell = pkgs.fish;
  };


  # ============================================================
  # PRINTING & SCANNING
  # ============================================================

  services.printing = {
    enable = true;
    drivers = [ pkgs.cnijfilter2 ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.udev.packages = [ pkgs.sane-airscan ];

  # allow unfree specifically for the canon printer driver
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "cnijfilter2" ];


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
  };

  services = {
    blueman.enable = true;
    upower.enable = true;
    gvfs.enable = true;
    tuned.enable = true;
    logind.settings.Login.HandleLidSwitch = "true";
    syncthing.enable = true;
  };


  # ============================================================
  # PACKAGES
  # ============================================================

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [];

  environment.systemPackages = with pkgs; [
    # --- editors & lsp ---
    helix
    nil                          # nix lsp
    vscode-langservers-extracted # html/css/json lsp

    # --- terminal & shell utils ---
    btop
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

    # --- desktop & theming ---
    noctalia-shell
    nwg-look
    adw-gtk3
    gtk3
    glib
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    desktop-file-utils
    kitty

    # --- files & drives ---
    nemo
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
    (ytm-player.overrideAttrs { doCheck = false; })
    youtube-tui

    # --- apps ---
    bitwarden-desktop
    obsidian
    qbittorrent
    nicotine-plus
    proton-vpn
    protonmail-desktop
    localsend
    dorion
    easyrpg-player

    # --- hyprland utils ---
    hyprshot
    hyprviz
    trayscale

    # --- hardware & connectivity ---
    android-tools
    scrcpy
    heimdall
    upower
    power-profiles-daemon

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


  # ============================================================
  # FONTS
  # ============================================================

  fonts.packages = with pkgs; [
    noto-fonts
    nerd-fonts.jetbrains-mono
    ubuntu-classic
  ];


  # ============================================================
  # SYSTEM
  # ============================================================

  system.stateVersion = "25.11"; # DO NOT EDIT

}
