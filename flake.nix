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

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.default =
        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [
            ./modules/tabline.nix
            {
              config.vim = {
                viAlias = true;
                vimAlias = true;
                theme = {
                  enable = true;
                  name = "nord";
                  transparent = false;
                };
                lsp = {
                  formatOnSave = true;
                  lightbulb.enable = true;
                  trouble.enable = true;
                  lspSignature.enable = true;
                };
                languages = {
                  enableLSP = true;
                  enableFormat = true;
                  enableTreesitter = true;
                  enableExtraDiagnostics = true;

                  nix.enable = true;
                };
                spellcheck.enable = true;
                statusline = {
                  lualine = {
                    enable = true;
                    theme = "nord";
                  };
                };
                terminal = {
                  toggleterm = {
                    enable = true;
                    lazygit.enable = true;
                  };
                };
                binds = {
                  whichKey.enable = true;
                  cheatsheet.enable = true;
                };
                autopairs.nvim-autopairs.enable = true;
              };
            }
          ];
        })
        .neovim;
    });
}
