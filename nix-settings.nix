{ ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Don't remove if shells are installed by other means, otherwise nix environment is not loaded correctly
  programs = {
    fish.enable = true;
    zsh.enable = true;
  };

}
