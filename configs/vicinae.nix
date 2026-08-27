{pkgs, ... }:
{
  programs.vicinae = {
    package = pkgs.vicinae;
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };   
  };
}
