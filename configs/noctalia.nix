# /configs/noctalia.nix
{ inputs, ... }:

{
  imports = [
    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
  ];

  # --- Noctalia Shell ---
  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.x86_64-linux.default;
    # systemd.enable = true;
    # recommendedServices.enable = true; 
  };

  # --- Noctalia Greeter ---
  programs.noctalia-greeter = {
    enable = true;
    package = inputs.noctalia-greeter.packages.x86_64-linux.default;
  };

  services.greetd.settings.default_session.user = "ven";
}
