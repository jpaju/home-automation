{ dotfiles, ... }:
{
  imports = [
    dotfiles.systemModules.nix-settings
    ./configuration.nix
    ./hardware-configuration.nix
    ./secrets
    ./ssh-server.nix
  ];
}
