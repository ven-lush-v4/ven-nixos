{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

 home-manager.users.ven = import ./home.nix;
 home-manager.useGlobalPkgs = true;
 home-manager.useUserPackages = true;
 home-manager.backupFileExtension = "backup";

 nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # the config for zram
  zramSwap = {
  enable = true;
  algorithm = "zstd";
  memoryPercent = 100;
 };

  # swappiness
  boot.kernel.sysctl = {
  "vm.swappiness" = 10;
 };

  # disable swap partition  
  swapDevices = [];

  services.logind.settings.Login.HandleLidSwitch = "true";  

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # Nix Store
  nix.settings.auto-optimise-store = true;

  # Garbage collection
  nix.gc = {
   automatic = true;
   dates = "weekly";
   options = "--delete-older-than 7d";
  };

  # Plymouth/boot animation
  boot.plymouth = {
  enable = true;
  theme = "dna";
  themePackages = with pkgs; [
    (adi1090x-plymouth-themes.override {
      selected_themes = [ "dna" ];
    })
  ];
};

#  services.displayManager.ly = {
#        enable = true;
#        settings = {
#         animation = "matrix";
#         vi_mode = false;
#         default_enviroment = "hyprland";
#        };
#  };

  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.kernelParams = [ "quiet" "splash" "udev.log_priority=3" ];
  boot.initrd.systemd.enable = false;

  services.getty.autologinUser = "ven"; 


  # Use latest kernel.
  #boot.kernelPackages = pkgs.linuxPackages_latest; # base linux kernel
  boot.kernelPackages = pkgs.cachyosKernels."linuxPackages-cachyos-latest"; # cachyos kernel | wait for cached version before uncommenting

  # Alternative Binary Caches
   nix.settings = {
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

  networking.hostName = "ven-nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  }; 
  services.blueman.enable = true;


  # tailscale
  services.tailscale = {
        enable = true;
  };

  services.openssh = {
  enable = true;
  settings = {
    PasswordAuthentication = true; # or false if you use keys
    PermitRootLogin = "no";
  };
 };

  # printing
  services.printing = {
   enable = true;
   drivers = [ pkgs.cnijfilter2 ];
  };

  services.avahi = {
   enable = true;
   nssmdns4 = true;
   openFirewall = true;
  };

  # scanning
 hardware.sane = {
  enable = true;
  extraBackends = [ pkgs.sane-airscan ];
 };

  services.udev.packages = [ pkgs.sane-airscan ];

 # allow unfree for canon driver
 nixpkgs.config.allowUnfreePredicate = pkg:
  builtins.elem (lib.getName pkg) [ "cnijfilter2" ];


  environment.etc. "xdg/autostart/kded6.desktop".source = "/dev/null";
  environment.pathsToLink = [ "/share/gsettings-schemas" "/share/glib-2.0" ];

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "gla";
  };

  # hyprland
        programs.hyprland = {
        enable = true;
        xwayland.enable = true;
  };

  #GPU + Vulkan 
  hardware.graphics = {
        enable = true;
        extraPackages = with pkgs ; [
                intel-media-driver
                mesa
                ];
        };


  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-hyprland];


  security.rtkit.enable = true;
  services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ven = {
    isNormalUser = true;
    description = "ven";
    extraGroups = [ "networkmanager" "wheel" "adbusers" "scanner" "lp" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };
  nix.settings.trusted-users = [ "root" "ven" ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # AppImage Support
  programs.appimage = {
  enable = true;
  binfmt = true;
 };

  # Packages - pks
  environment.systemPackages = with pkgs; [
  helix
  # add languages below:
  nil # nix
  vscode-langservers-extracted # html + css/json
  # end of languages
  fd
  android-tools
  scrcpy
  lazygit
  hyprshot
  trayscale
  blueman
  gparted
  udisks2
  udiskie
  localsend
  exfatprogs
  xdelta
  easyrpg-player
  system-config-printer
  simple-scan
  desktop-file-utils
  gtk3
  glib
  bitwarden-desktop
  obsidian
  libsForQt5.qt5ct
  qt6Packages.qt6ct
  btop
  git
  gh
  fzf
  power-profiles-daemon
  python3
  curl
  microfetch
  cmatrix
  tldr
  rmpc  
  noctalia-shell
  dorion
  hyprviz
  gimp
  kdePackages.kdenlive
  qbittorrent
  nicotine-plus
  nemo
  proton-vpn
  protonmail-desktop
  nh
  jq
  obs-studio
  youtube-tui
  nwg-look
  adw-gtk3
  vlc
  upower
  navi
  heimdall
  file-roller
  kitty
  syncthingtray
  (ytm-player.overrideAttrs { doCheck = false; })
  ];

  # Flatpak Packages
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

#  let
#  qbt-tui = pkgs.buildGoModule {
#    pname = "qbt-tui";
#    version = "unstable";
#    src = pkgs.fetchFromGitHub {
#      owner = "nickvanw";
#      repo = "qbittorrent-tui";
#      rev = "main";
#      sha256 = pkgs.lib.hGdgeU2Nk87RAuZyYjyDjFL6LK7dAZN5RE9%2BhrDTkDU%3D;
#    };
#    vendorHash = pkgs.lib.hGdgeU2Nk87RAuZyYjyDjFL6LK7dAZN5RE9%2BhrDTkDU%3D;
#  };
# in

#  manual package enabling:
  programs.steam.enable = true;
  programs.fish.enable = true;
  programs.kdeconnect.enable = true;
  programs.dconf.enable = true;
  services.upower.enable = true;
  services.gvfs.enable = true;
  services.tuned.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
      ]; 

 fonts.packages = with pkgs; [
        noto-fonts
        nerd-fonts.jetbrains-mono
        ubuntu-classic
  ];

  system.stateVersion = "25.11"; # DO NOT EDIT

}
