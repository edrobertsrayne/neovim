{
  description = "Ed's Neovim configuration based on notashelf/nvf";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: {
    packages.x86_64-linux = {
      default =
        (inputs.nvf.lib.neovimConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            {
              config.vim = {
                viAlias = true;
                vimAlias = true;
                theme = {
                  enable = true;
                  name = "nord";
                  transparent = false;
                };
                spellcheck.enable = true;
                statusline = {
                  lualine = {
                    enable = true;
                    theme = "nord";
                  };
                };
              };
            }
          ];
        })
        .neovim;
    };
  };
}
