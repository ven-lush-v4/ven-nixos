{
  description = "ven-nixos";
  # ============================================================
  # INPUTS
  # ============================================================

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
     	url = "github:noctalia-dev/noctalia/cachix/";
	  };

	  noctalia-greeter = {
	    url = "github:noctalia-dev/noctalia-greeter";
	  };
   
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

   # vicinae.url = "github:vicinaehq/vicinae";

    helium = {
      url = "github:AlvaroParker/helium-nix/165e62236f2f5793a9672204f966c2d12b6e2d3e";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

 };


  # ============================================================
  # OUTPUTS
  # ============================================================

  outputs = { nixpkgs, home-manager, self, nix-index-database, helium, nix-flatpak, noctalia, noctalia-greeter, lix-module, ... }@inputs: {
    nixosConfigurations.ven-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.default
        nix-index-database.nixosModules.nix-index
        nix-flatpak.nixosModules.nix-flatpak
        lix-module.nixosModules.lixFromNixpkgs
        # vicinae.nixosModules.default
         { home-manager.extraSpecialArgs = { inherit inputs; }; }
        # overlays
        {
          nixpkgs.overlays = [
          ];
        }
        
        # packages via flake inputs 
        {
          environment.systemPackages = [
            helium.packages.x86_64-linux.default
            # noctalia.packages.x86_64-linux.default
          ];
        }

        # misc options
        { programs.nix-index-database.comma.enable = true; }
      ];
    };
  };
}
