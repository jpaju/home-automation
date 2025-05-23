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

  # Don't remove if shells are installed by other means, otherwise nix environment is not loaded correctly
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
  networking.firewall = {
    enable = true;

    allowedTCPPorts = let
      hass = 8123;
      mqtt = 1883;
    in [ hass mqtt ];

    allowedUDPPorts = let
      ssdp = 1900;
      mdns = 5353;
      coap = 5683; # Shelly CoIoT
    in [ ssdp mdns coap ];
  };

  virtualisation.docker.enable = true;

  systemd.services.home-automation = {
    enable = true;
    path = [ pkgs.docker ];
    requires = [ "docker.service" ];
    after = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/etc/nixos";
      ExecStart = "${pkgs.docker}/bin/docker compose up -d --remove-orphans";
      ExecReload = "${pkgs.docker}/bin/docker compose up -d";
      ExecStop = "${pkgs.docker}/bin/docker compose down";
      TimeoutStartSec = 0;
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = "24.11"; # DO NOT CHANGE THIS

}

