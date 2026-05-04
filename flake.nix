{
  description = "ven-nixos";

#  nixConfig = {
 #   extra-substituters = [ "https://attic.xuyh0120.win/lantian" ];
  #  extra-trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
 # };

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nix-index-database.url = "github:nix-community/nix-index-database";
  inputs.nix-index-database.inputs.nixpkgs.follows = "nixpkgs"; 
 inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

  outputs = { nixpkgs, home-manager, self, nix-index-database, nix-cachyos-kernel,  ... }: {
    nixosConfigurations.ven-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
	home-manager.nixosModules.default
	nix-index-database.nixosModules.nix-index
	{ programs.nix-index-database.comma.enable = true; }	
{ nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ]; }
      ];
    };
  };
}
