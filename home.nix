{ pkgs, config, ... }: {


  imports = [
    ./configs/configs.nix
  ];
 

  home.file = {
  };
  # ============================================================
  # HOME
  # ============================================================

  home = {
    username = "ven";
    homeDirectory = "/home/ven";
    stateVersion = "26.05";
    sessionPath = [ "$HOME/.local/bin" ];

    # imports = [

          # ];

    packages = with pkgs; [
      brightnessctl
      wl-clipboard
      xdg-utils
    ];

    pointerCursor = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
      size = 24;
    };
  };
  fonts.fontconfig.enable = true;
  # ============================================================
  # THEMING
  # ============================================================

  xdg.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Gradient-Dark-Icons";
    };
    font = {
      name = "Ubuntu Mono";
      size = 12;
    };
    gtk4.theme = null;
  };

  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
  };

  # ============================================================
  # PROGRAMS
  # ============================================================
  programs.home-manager.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      name = "Maple Mono NF";
      size = 12;
    };
    settings = {
      scrollback_lines = 5000;
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };
    extraConfig = ''
      include themes/noctalia.conf
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.eza = {
  enable = true;
  enableFishIntegration = true;
  extraOptions = [
      # "-l"
      "--icons"
      "--git"
      "--group-directories-first"
      # "--time-style=relative"
      "--no-user"
      "--no-permissions"
    ];
 };

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -g fish_greeting ""
    '';

    loginShellInit = ''
      if status is-login
      and test (tty) = /dev/tty1
        exec sway
      end
    '';

     functions = {
    y = ''
      set tmp (mktemp -t "yazi-cwd.XXXXXX")
      command yazi $argv --cwd-file="$tmp"
      if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
      end
      command rm -f -- "$tmp"
    '';
  };

    plugins = [
      { name = "z";        src = pkgs.fishPlugins.z.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
      { name = "done";     src = pkgs.fishPlugins.done.src; }
      { name = "sponge";   src = pkgs.fishPlugins.sponge.src; }
    ];

    shellAliases = {
      # nix
      nix-rebuild    = "nh os switch /etc/nixos";
      nix-update     = "nh os boot --update /etc/nixos && shutdown now ";
      nix-test       = "nh os test /etc/nixos";
      nix-generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      nix-clean = "sudo nix-collect-garbage -d && nh clean all && nix-store --optimise && nh os boot";
      nix-recovery = "fsck.fat -f /dev/sda1/ && fsck.ext4 -f /dev/sda4 && sudo mount /dev/sda1 /boot && sudo mount /dev/sda4 /home && exit";
      
      # quick config editing
      nixconf   = "sudo nano /etc/nixos/configuration.nix";
      homeconf  = "sudo nano /etc/nixos/home.nix";
      swayconf = "sudo nano /etc/nixos/sway/config";
      flakeconf = "sudo nano /etc/nixos/flake.nix";
      hxnix = "sudo hx /etc/nixos/";
      hxflake = "sudo hx /etc/nixos/flake.nix";
      hxhome = "sudo hx /etc/nixos/home.nix";
      hxsway = "sudo hx /etc/nixos/sway/config";

      # git
      gitnix   = "sudo lazygit -p /etc/nixos";
      gitaddnix = "sudo git -C /etc/nixos add .";

      # misc
      fetch       = "microfetch";
      adb-phone   = "adb connect ven-phone:5555";
      scrcpy      = "scrcpy --max-size 1080 --window-width 540 --window-height 1200";

      # linux commands
      c = "clear";
      ls = "eza --icons=always";
      # "ls -la" = "eza -a --icons=always";
      lt = "eza -T --icons=always";
      lsl = "eza -l --icons=always";      
      cd = "z";
    };
  };


  # ============================================================
  # SYNCTHING
  # ============================================================
  services.syncthing.enable = true;
  services.syncthing.tray = {
    enable = true;
    package = pkgs.syncthingtray;
  };


  # ============================================================
  # SWAY{fx} (home-manager managed)
  # ============================================================

  
  wayland.windowManager.sway = {
  enable = true;
  package = pkgs.swayfx;
  checkConfig = false;
  config.bars = [];
  extraConfig = builtins.readFile ./sway/config;
 };
 

 xdg.desktopEntries.helixnotes = {
  name = "HelixNotes";
  comment = "Notes app";
  exec = "${config.home.homeDirectory}/.local/bin/HelixNotes";
  icon = "${config.home.homeDirectory}/Pictures/icons/helixnotes.png";
  terminal = false;
  categories = [ "Utility" "Office" ];
};

}
