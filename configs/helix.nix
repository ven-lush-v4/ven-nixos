{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];

    settings = {
      theme = "noctalia"; # or whatever your generated template name is
      editor = {
        cursorline = true;
        bufferline = "multiple";
        idle-timeout = 50;
        # rulers = [ 80 ];
        color-modes = true;
        indent-guides.render = true;
        whitespace.render = {
          space = "none";
          tab = "all";
          newline = "none";
        };
        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
            "file-modification-indicator"
          ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-type"
          ];
        };
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
          auto-signature-help = true;
        };
        inline-diagnostics.cursor-line = "warning";
        file-picker.hidden = false;
      };
    };

    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "nixfmt";
      }
    ];

    languages.language-server.nixd = {
      command = "nixd";
      config.nixd = {
        nixpkgs.expr = "import (builtins.getFlake \"/etc/nixos\").inputs.nixpkgs { }";
        formatting.command = [ "nixfmt" ];
        options = {
          nixos.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.ven-nixos.options";
          home-manager.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.ven-nixos.options.home-manager.users.type.getSubOptions []";
        };
      };
    };
  };
}
