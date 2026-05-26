{
  description = "ven-nixos";


  # ============================================================
  # INPUTS
  # ============================================================

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
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

  outputs = { nixpkgs, home-manager, self, nix-index-database, nix-cachyos-kernel, helium, ytm-player, nix-flatpak, ... }: {
    nixosConfigurations.ven-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.default
        nix-index-database.nixosModules.nix-index
        nix-flatpak.nixosModules.nix-flatpak

        # overlays
        {
          nixpkgs.overlays = [
            nix-cachyos-kernel.overlays.pinned
            ytm-player.overlays.default
          ];
        }

        # extra packages (not in nixpkgs)
        {
          environment.systemPackages = [
            helium.packages.x86_64-linux.default
	#    claude-desktop.packages.x86_64-linux.default
          ];
        }

        # misc options
        { programs.nix-index-database.comma.enable = true; }
      ];
    };
  };
}
