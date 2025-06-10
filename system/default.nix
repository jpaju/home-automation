{ dotfiles, ... }: {
  imports = [ # Newline
    dotfiles.systemModules.nix-settings
    ./hardware-configuration.nix
    ./configuration.nix
    ./ssh-server.nix
  ];
}
