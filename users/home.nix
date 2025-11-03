{
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

  imports = [
    ./secrets.nix
    dotfiles.exports.options
    dotfiles.exports.home
  ];
}
