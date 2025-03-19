{ pkgs, lib, config, hostname, inputs, ... }:

{
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}