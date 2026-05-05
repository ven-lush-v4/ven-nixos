{
  description = "ven-nixos";

#  nixConfig = {
 #   extra-substituters = [ "https://attic.xuyh0120.win/lantian" ];
  #  extra-trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
 # };

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nix-index-database.url = "github:nix-community/nix-index-database";
  inputs.nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  nix.flatpak.url = "github:gmodena/nix-flatpak"; 
 inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  inputs.helium = {
	url = "github:AlvaroParker/helium-nix";
  inputs.nixpkgs.follows = "nixpkgs";
};

  outputs = { nixpkgs, home-manager, self, nix-index-database, nix-cachyos-kernel, helium, nix-flatpak,  ... }: {
    nixosConfigurations.ven-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
	home-manager.nixosModules.default
	nix-index-database.nixosModules.nix-index
	nix-flatpak.nixosModules.nix-flatpak
	{ programs.nix-index-database.comma.enable = true; }	
{ nixpkgs.overlays = [ nix-cachyos-kernel.overlays.default ]; }

{
  environment.systemPackages = [
    helium.packages.x86_64-linux.default
    waterfox.packages.x86_64-linux.default
  ];
}
      ];
    };
  };
}
