{ dotfiles, ... }: {
  imports = [ # Newline
    dotfiles.systemModules.nix-settings
    ./configuration.nix
    ./hardware-configuration.nix
    ./secrets
    ./ssh-server.nix
  ];
}
