# configs.nix - imports all configs (for home.nix)
{...}:
{
  imports = [
    # ./noctalia.nix - is imported in ../configuration.nix
    ./starship.nix
    ./vicinae.nix
    ./helix.nix
  ];
}
