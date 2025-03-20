{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, mac-app-util, home-manager, ... }:
  let
    configuration = { pkgs, ... }: {
      users.users.bazusa = {
        name = "bazusa";
        home = "/Users/bazusa";
      };

      system.stateVersion = 6;
    };
  in
  {
    darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        ./modules/system.nix
        mac-app-util.darwinModules.default
        home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.bazusa = import ./modules/home.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
      ];
    };
  };
}
