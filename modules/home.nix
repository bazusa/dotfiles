{ pkgs, lib, config, inputs, ... }:

{
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      cls = "clear";
      switch = "darwin-rebuild switch --flake ~/.dotfiles";
    };
  };
}