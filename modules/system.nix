{ config, pkgs, ... }:

{
  nix.enable = false;

  networking.hostName = "bron";
  networking.localHostName = "bron";
  networking.computerName = "bron";

  nixpkgs.hostPlatform = "x86_64-darwin";
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs [
    vim
    iterm2
  ];
}
