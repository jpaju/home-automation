{ pkgs, dotfiles, username, userhome, ... }: {
  programs.home-manager.enable = true;

  home = {
    stateVersion = "25.05";
    username = username;
    homeDirectory = userhome;
  };

  imports = with dotfiles.homeModules; [ cli-tools dev-tools nix shell ];

  home.packages = [ pkgs.mqttui ];
}
