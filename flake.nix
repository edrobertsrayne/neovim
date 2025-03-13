{
  description = "Ed's Neovim configuration based on notashelf/nvf";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };
  outputs = {nixpkgs, ...} @ inputs: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    makeNeovimConfig = pkgs:
      inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [
          ./modules/keymaps.nix
          ./modules/languages.nix
          ./modules/options.nix
          ./modules/plugins.nix
          {
            config.vim = {
              viAlias = true;
              vimAlias = true;
              theme = {
                enable = true;
                name = "nord";
                transparent = false;
              };
            };
          }
        ];
      };
  in {
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      neovimConfig = makeNeovimConfig pkgs;
    in {
      default = neovimConfig.neovim;
    });

    nixosModules.default = {
      config,
      pkgs,
      ...
    }: {
      options = {
        programs.ed-neovim = {
          enable = nixpkgs.lib.mkEnableOption "Ed's Neovim configuration";
        };
      };

      config = nixpkgs.lib.mkIf config.programs.ed-neovim.enable {
        environment.systemPackages = [
          (makeNeovimConfig pkgs).neovim
        ];
      };
    };

    homeManagerModules.default = {
      config,
      pkgs,
      ...
    }: {
      options.programs.ed-neovim = {
        enable = nixpkgs.lib.mkEnableOption "Ed's Neovim configuration";
      };

      config = nixpkgs.lib.mkIf config.programs.ed-neovim.enable {
        home.packages = [
          (makeNeovimConfig pkgs).neovim
        ];
      };
    };
  };
}
