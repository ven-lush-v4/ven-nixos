{ config, pkgs, ... }: {


  # ============================================================
  # HOME
  # ============================================================

  home = {
    username = "ven";
    homeDirectory = "/home/ven";
    stateVersion = "25.11";
    sessionPath = [ "$HOME/.local/bin" ];

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
    platformTheme.name = "gtk";
  };


  # ============================================================
  # PROGRAMS
  # ============================================================

  programs.home-manager.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      name = "Ubuntu Mono";
      size = 13;
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

  programs.starship = {
    enable = true;
    settings = {
      format = "$os$username$directory$git_branch$git_status$cmd_duration$line_break$character";

      nodejs.disabled = true;
      python.disabled = true;
      rust.disabled = true;

      os.disabled = false;

      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch.symbol = " ";

      cmd_duration.min_time = 2000;
    };
  };

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -g fish_greeting ""
    '';

    loginShellInit = ''
      if status is-login
      and test (tty) = /dev/tty1
        exec start-hyprland
      end
    '';

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
      nix-update     = "nh os boot --update /etc/nixos";
      nix-test       = "nh os test /etc/nixos";
      nix-generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      nix-clean = "sudo nix-collect-garbage -d && nh clean all && nix-store --optimise";

      # quick config editing
      nixconf   = "sudo nano /etc/nixos/configuration.nix";
      homeconf  = "sudo nano /etc/nixos/home.nix";
      hyprconf  = "sudo nano ~/.config/hypr/hyprland.conf";
      flakeconf = "sudo nano /etc/nixos/flake.nix";
      hxnix = "hx /etc/nixos/configuration.nix";
      hxflake = "hx /etc/nixos/flake.nix";
      hxhome = "hx /etc/nixos/home.nix";
      hxhypr = "hx ~/.config/hypr/hyprland.conf";

      # git
      gitnix   = "sudo lazygit -p /etc/nixos";
      githypr  = "sudo lazygit -p ~/.config/hypr";

      # misc
      fetch       = "microfetch";
      adb-phone   = "adb connect ven-phone:5555";
      scrcpy      = "scrcpy --max-size 1080 --window-width 540 --window-height 1200";
      qbitorrent  = "qbittorrent -d && proton-vpn -d";
    };
  };


  # ============================================================
  # SERVICES
  # ============================================================

  services.syncthing.enable = false;


  # ============================================================
  # HYPRLAND (home-manager managed - currently unused)
  # ============================================================

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   plugins = with pkgs.hyprlandPlugins; [
  #     # hyprspace       - broken
  #     # borders-plus-plus - broken on hyprland 0.54.x as of 5/5/2026
  #     # hyprgrass       - son.
  #     # hyprexpo        - </3
  #   ];
  # };

}
