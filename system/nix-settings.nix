{ ... }: {
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Don't remove if shells are installed by other means, otherwise nix environment is not loaded correctly
  programs = {
    fish.enable = true;
    zsh.enable = true;
  };

}
