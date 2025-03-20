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

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
    ];
    profiles.default.userSettings = {
      "editor.fontFamily" = "Hack Nerd Font";
      "editor.fontSize" = 14;
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.lineHeight" = 1.4;
      "editor.minimap.enabled" = false;
      "editor.renderWhitespace" = "all";
      "editor.tabSize" = 2;
      "editor.wordWrap" = "on";
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 1000;
      "files.trimTrailingWhitespace" = true;
      "workbench.colorTheme" = "Catppuccino Macchiato";
    };
  };
}