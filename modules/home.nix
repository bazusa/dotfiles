{ pkgs, lib, config, inputs, ... }:

{
  home.username = "bazusa";
  home.homeDirectory = "/Users/bazusa";
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}