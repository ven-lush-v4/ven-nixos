# boot.nix

{pkgs, ...}:
{ boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 10;
    efi.canTouchEfiVariables = true;
};
 boot.plymouth = {
    enable = true;
    theme = "dna";
    themePackages = with pkgs; [
      (adi1090x-plymouth-themes.override {
        selected_themes = [ "dna" ];
      })
    ];
};
    services.getty.autologinUser = "ven";
}
