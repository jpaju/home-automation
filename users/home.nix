{
  inputs,
  lib,
  system,
  username,
  userhome,
  homeStateVersion,
  ...
}:
{
  programs.home-manager.enable = true;

  programs.helix.package = lib.mkForce (
    inputs.helix.packages.${system}.default.override {
      includeGrammarIf = grammar: grammar.name != "perl";
    }
  );

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
