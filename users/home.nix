{
  pkgs,
  dotfiles,
  username,
  userhome,
  homeStateVersion,
  ...
}:
{
  programs.home-manager.enable = true;

  home = {
    stateVersion = homeStateVersion;
    username = username;
    homeDirectory = userhome;
  };

  imports =
    let
      otherModules = [ ./secrets.nix ];
      dotfilesModules = with dotfiles.homeModules; [
        ai
        cli-tools
        dev-tools
        nix
        shell
      ];
    in
    dotfilesModules ++ otherModules;

  home.packages = [ pkgs.mqttui ];
}
