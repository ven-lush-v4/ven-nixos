{ config, pkgs, lib, inputs, ... }:

{
  imports = [ 
     ./hardware-configuration.nix
     ./modules/kernel.nix
     ./modules/boot.nix
     ./modules/packages.nix
     ./modules/caches.nix
     ./modules/locale.nix
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


  fileSystems."/mnt/torrent-usb" = {
  device = "/dev/disk/by-label/torrent-usb";
  fsType = "exfat";
  options = [ "nofail" "x-systemd.automount" "uid=1000" "gid=100" ];
  };  
  

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
  networking.firewall.allowedTCPPorts = [22 5555 8080];
  networking.firewall.allowedUDPPorts = [ 19132 ];
  networking.nameservers = ["1.1.1.1" "1.0.0.1"];
  
  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
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

  security.sudo.extraConfig = ''
  Defaults:ven env_keep += "XDG_CONFIG_HOME"
'';

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


  #=============================================================
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
