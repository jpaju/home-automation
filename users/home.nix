{
  inputs,
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
    inputs.dotfiles.exports.options
    inputs.dotfiles.exports.home
  ];
}
