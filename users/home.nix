{ dotfiles, username, userhome, ... }: {
  programs.home-manager.enable = true;

  home = {
    stateVersion = "25.05";
    username = username;
    homeDirectory = userhome;
  };

  imports = with dotfiles.homeManagerModules; [ fish starship zellij cli-tools dev-tools ];

}
