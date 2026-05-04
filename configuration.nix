
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
  memoryPercent = 50;
};

 services.logind.settings.Login.HandleLidSwitch = "true";  

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.getty.autologinUser = "ven";
   
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

boot.consoleLogLevel = 3;
boot.initrd.verbose = false;
boot.kernelParams = [ "quiet" "splash" "udev.log_priority=3" ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings = {
	substituters = [ "https://attic.xuyh0120.win/lantian" ];
	trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
};
  networking.hostName = "ven-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


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
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # pks
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
  tailscale
  trayscale
  blueman
  gparted
  udisks2
  udiskie
  easyrpg-player
  lutris
  popsicle
  system-config-printer
  desktop-file-utils
  gtk3
  glib
  libsForQt5.qt5ct
  qt6Packages.qt6ct
  btop
  git
  gh
  fzf
  python3
  wget
  curl
  microfetch
  cmatrix  
  noctalia-shell
  vesktop
  gimp
  kdePackages.kdenlive
  qbittorrent
  google-chrome
  chromium
  libreoffice
  nemo
  proton-vpn
  protonmail-desktop
  nh
  obs-studio
  evtest
  pear-desktop
  nwg-look
  adw-gtk3
  vlc
  upower
  ventoy
  file-roller
  kitty
  ];

#  manual package enabling:
  programs.steam.enable = true;
  programs.fish.enable = true;
  programs.kdeconnect.enable = true;
  programs.dconf.enable = true;
  services.upower.enable = true;
  services.gvfs.enable = true;

nixpkgs.config.permittedInsecurePackages = [
      "ventoy-1.1.10"
      ]; 

 fonts.packages = with pkgs; [
	noto-fonts
	nerd-fonts.jetbrains-mono
	ubuntu-classic
];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
