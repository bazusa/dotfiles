{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, mac-app-util }:
  {
    darwinConfigurations."bron" = nix-darwin.lib.darwinSystem {
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      modules = [
        ./modules/system.nix
        mac-app-util.darwinModules.default
        ];
    };
  };
}