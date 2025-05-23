{ pkgs, username, ... }: {
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.vmware.guest.enable = true;

  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    #   font = "Lat2-Terminus16";
    keyMap = "fi";
    #   useXkbConfig = true; # use xkb.options in tty.
  };

  # Don't remove even if shells are installed by other means,
  # or nix environment might not loaded correctly
  programs = {
    fish.enable = true;
    zsh.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  networking.hostName = "home-automation";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = "24.11"; # DO NOT CHANGE THIS

}

