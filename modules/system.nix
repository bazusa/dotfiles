{ config, pkgs, ... }:

{
  nix.enable = false;
  nixpkgs.hostPlatform = "x86_64-darwin";
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "bron";
  networking.localHostName = "bron";
  networking.computerName = "bron";

  environment.systemPackages = with pkgs; [
    vim
    iterm2
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  system.defaults = {
    dock.autohide = false;
    dock.persistent-apps = [
      "${pkgs.iterm2}/Applications/iTerm2.app"
      "/System/Applications/Mail.app"
    ];
  };

}
