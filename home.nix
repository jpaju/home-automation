{ pkgs, dotfiles, username, userhome, ... }: {
  programs.home-manager.enable = true;

  home = {
    stateVersion = "25.05";
    username = username;
    homeDirectory = userhome;
    packages = with pkgs; [ tree fzf ];
  };

  imports = with dotfiles.homeManagerModules; [ fish git gh starship helix zellij ];

}
