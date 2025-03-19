{ pkgs, ... }: {
  nix.enable = false;
  system.stateVersion = "23.11";
  environment.systemPackages = with pkgs; [
    vscode
  ];
  nixpkgs.hostPlatform = "x86_64-darwin";
  nixpkgs.config.allowUnfree = true;
}