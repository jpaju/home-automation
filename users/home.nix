{ pkgs, dotfiles, username, userhome, ... }: {
  programs.home-manager.enable = true;

  home = {
    stateVersion = "25.05";
    username = username;
    homeDirectory = userhome;
  };

  imports = with dotfiles.homeModules; [ nix fish starship zellij cli-tools dev-tools ];

  home.packages = [ pkgs.mqttui ];
}
