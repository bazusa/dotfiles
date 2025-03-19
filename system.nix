{ pkgs, ... }: {
  nix.enable = false;
  environment.systemPackages = with pkgs; [
    vscode
  ];
  nixpkgs.hostPlatform = "x86_64-darwin";
  nixpkgs.config.allowUnfree = true;
}