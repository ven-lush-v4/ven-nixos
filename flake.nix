{
  description = "ven-nixos";


  # ============================================================
  # INPUTS
  # ============================================================

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
	url = "github:noctalia-dev/noctalia-shell/65c4bf42f4cc78261744a09973def2599bebca28";
	};


     gzml-shell = {
      url = "github:zero-j89/gzml_shell";
     inputs.nixpkgs.follows = "nixpkgs";
     };
    
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ytm-player.url = "github:peternaame-boop/ytm-player";

    claude-desktop.url = "github:patrickjaja/claude-desktop-bin";
  };


  # ============================================================
  # OUTPUTS
  # ============================================================

  outputs = { nixpkgs, home-manager, self, nix-index-database, nix-cachyos-kernel, helium, ytm-player, nix-flatpak, claude-desktop, noctalia, gzml-shell,  ... }: {
    nixosConfigurations.ven-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.default
        nix-index-database.nixosModules.nix-index
        nix-flatpak.nixosModules.nix-flatpak
        { home-manager.users.ven.imports = [ gzml-shell.homeModules.default ]; }
        # overlays
        {
          nixpkgs.overlays = [
            nix-cachyos-kernel.overlays.pinned
            ytm-player.overlays.default
            # gzml-shell.overlays.default
          ];
        }

        # extra packages (not in nixpkgs) 
        {
          environment.systemPackages = [
            helium.packages.x86_64-linux.default
	          claude-desktop.packages.x86_64-linux.default
            noctalia.packages.x86_64-linux.default
          ];
        }

        # misc options
        { programs.nix-index-database.comma.enable = true; }
      ];
    };
  };
}
