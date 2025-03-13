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
            ./modules/theme.nix
            ./modules/lsp.nix
            ./modules/toggleterm.nix
            ./modules/binds.nix
            ./modules/statusline.nix
            ./modules/misc.nix
            ./modules/options.nix
            {
              config.vim = {
                viAlias = true;
                vimAlias = true;
              };
            }
          ];
        })
        .neovim;
    });
}
