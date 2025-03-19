{ pkgs, ... }: {
  nix.enable = false;
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;

  environment.systemPackages = with pkgs; [
    vscode
  ];
  nixpkgs.hostPlatform = "x86_64-darwin";
  nixpkgs.config.allowUnfree = true;
}