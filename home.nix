{ pkgs, dotfiles, username, userhome, ... }: {
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.username = username;
  home.homeDirectory = userhome;

  home.packages = with pkgs; [ tree fzf ];

  imports = with dotfiles.homeManagerModules; [ fish git gh starship helix zellij ];
}
