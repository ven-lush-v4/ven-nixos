{ config, pkgs, lib, ... }:

{
  imports = [ 
     ./hardware-configuration.nix
   # ./modules/kernel.nix
   # ./modules/boot.nix
   # ./modules/packages.nix
   # ./modules/caches.nix
   # ./modules/locale.nix
     ];


  # ============================================================
  # NIX & HOME MANAGER
  # ============================================================

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = false;
    trusted-users = [ "root" "ven" ];
    max-jobs = 1;
    cores = 1;
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://attic.xuyh0120.win/lantian"
      # "https://cache.garnix.io"
      "https://noctalia.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  nix.gc = {
    automatic = false;
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

  # kernel - cachyos(1) or zen(2)
  #boot.kernelPackages = pkgs.cachyosKernels."linuxPackages-cachyos-latest";
  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.kernelParams = [ "quiet" "splash" "udev.log_priority=3" ];
  boot.kernel.sysctl."vm.swappiness" = 10;
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.initrd.systemd.enable = false;
  boot.kernel.sysctl = {
  "vm.vfs_cache_pressure" = 50;  # default 100, keeps file cache longer
  "vm.dirty_ratio" = 10;
  "vm.dirty_background_ratio" = 5;
  };
  powerManagement.cpuFreqGovernor = "schedutil";
  services.udev.extraRules = ''
  ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/scheduler}="mq-deadline"
  '';

  boot.blacklistedKernelModules = [
  "joydev"             # joystick - xbox controller on wayland doesn't use this
  "mousedev"           # legacy mouse interface - wayland uses evdev
  "mac_hid"            # mac HID compat layer - you're not on a mac lol
  "serio_raw"          # raw serio interface - nothing needs it
  "8250_dw"            # designware serial UART - not needed
  "snd_seq_dummy"      # dummy midi sequencer
  "dmi_sysfs"          # dmi info via sysfs - not critical
  "intel_powerclamp"   # intel cpu power clamping - earlyoom handles pressure instead
  "tiny_power_button"  # alternative power button handler - redundant
  "ahci"
  "libahci"
];

  fileSystems."/mnt/torrent-usb" = {
  device = "/dev/disk/by-label/torrent-usb";
  fsType = "exfat";
  options = [ "nofail" "x-systemd.automount" "uid=1000" "gid=100" ];
  };  
  

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
  networking.firewall.trustedInterfaces = ["proton0" "pvpnksintrf0"];
  networking.firewall.allowedTCPPorts = [22 5555];
  networking.nameservers = ["1.1.1.1" "1.0.0.1"];
  
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

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];
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

  # ============================================================
  # FONTS
  # ============================================================

  fonts.packages = with pkgs; [
    noto-fonts
    nerd-fonts.jetbrains-mono
    ubuntu-classic
    maple-mono.NF
    nerd-fonts.space-mono
  ];


  # ============================================================
  # SYSTEM
  # ============================================================

  system.stateVersion = "25.11"; # DO NOT EDIT

}
