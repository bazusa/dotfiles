{
  description = "dotfiles nix-darwin flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, mac-app-util }:
  {
    darwinConfigurations."bron" = nix-darwin.lib.darwinSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        ./system.nix
        mac-app-util.darwinModules.default
        ];
    };
  };
}
