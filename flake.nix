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
      environment.systemPackages =
        [ pkgs.vim
        ];

      nix.enable = false;
      #system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in
  {
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        mac-app-util.darwinModules.default
        home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              # useUserPackages = true;
              users.bazusa = import ./modules/home.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
      ];
    };
  };
}