{ config, pkgs, ... }: {




 home.username = "ven";
 home.homeDirectory = "/home/ven";
 home.stateVersion = "25.11";

 home.packages = with pkgs; [
	brightnessctl
	wl-clipboard
	xdg-utils
];

 home.sessionPath = [ "$HOME/.local/bin" ];
 fonts.fontconfig.enable = true;
#  home.file.".local/share/icons/Material-Black-Blueberry-Numix" = {
#   source = "${pkgs.material-black-colors}/share/icons/Material-Black-Blueberry-Numix";
#   recursive = true;

#  home.file.".local/share/fonts/DeterminationSansWebRegular-369X.ttf" = {
 #  source = ./DeterminationSansWebRegular-369X.ttf;
# };

 programs.kitty = {
	enable = true;
	font = {
        name =  "Ubuntu Mono";
	size = 13;
	};
	settings = {
	scrollback_lines = 5000;
	enable_audio_bell = false;
	confirm_os_window_close = 0;
	};
	extraConfig = ''
         include themes/Noctalia.conf
'';
};


	programs.starship = {
  enable = true;
  settings = {
    format = "$os$username$directory$git_branch$git_status$cmd_duration$line_break$character";
	nodejs.disabled = true;
	python.disabled = true;
	rust.disabled = true;  
  
    os = {
      disabled = false;
    };
    
    character = {
      success_symbol = "[❯](green)";
      error_symbol = "[❯](red)";
    };
    
    directory = {
      truncation_length = 3;
      truncate_to_repo = true;
    };
    
    git_branch = {
      symbol = " ";
    };
    
    cmd_duration = {
      min_time = 2000;
    };
  };
};


programs.fish = {
	enable = true;
	interactiveShellInit = ''
	 set -g fish_greeting "" 
 '';
	plugins = [
    {
      name = "z";
      src = pkgs.fishPlugins.z.src;
    }
    {
      name = "fzf-fish";
      src = pkgs.fishPlugins.fzf-fish.src;
    }
    {
      name = "autopair";
      src = pkgs.fishPlugins.autopair.src;
    }
    {
      name = "done";
      src = pkgs.fishPlugins.done.src;
    }
    {
      name = "sponge";
      src = pkgs.fishPlugins.sponge.src;
    }
  ];

loginShellInit = ''
	if test (tty) = /dev/tty1
	 exec start-hyprland
	end
 '';	
shellAliases = {
nix-rebuild = "nh os switch /etc/nixos";
nix-update = "nh os switch --update /etc/nixos";
nix-test = "nh os test /etc/nixos";
nix-generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
nixconf = "sudo nano /etc/nixos/configuration.nix";
homeconf = "sudo nano /etc/nixos/home.nix";
hyprconf = "sudo nano ~/.config/hypr/hyprland.conf";
flakeconf = "sudo nano /etc/nixos/flake.nix";
fetch = "microfetch";
gitnix = "sudo lazygit -p /etc/nixos";
githypr = "sudo lazygit -p ~/.config/hypr";
gittalia = "sudo lazygit -p ~/.config/noctalia";
adb-phone = "adb connect ven-phone:5555";
scrcpy = "scrcpy --max-size 1080 --window-width 540 --window-height 1200";
	};
};

home.pointerCursor = {
  name = "capitaine-cursors";
  package = pkgs.capitaine-cursors;
  size = 24;
};

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
	name = "Determination";
	size = 10;
	};
};
gtk.gtk4.theme = null;

qt = {
  enable = true;
  platformTheme.name = "gtk";
 # style = {
 #   name = "qt5ct";
 #   package = pkgs.catppuccin-qt5ct;
 # };
};

programs.home-manager.enable = true;

# HYPRLAND
# wayland.windowManager.hyprland = {
# 	enable = true;
}

