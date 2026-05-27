{ inputs, ... }:
{
  imports = [
    inputs.dotfiles.systemModules.nix-settings
    inputs.dotfiles.inputs.determinate.nixosModules.default
    ./configuration.nix
    ./hardware-configuration.nix
    ./secrets
    ./ssh-server.nix
  ];
}
