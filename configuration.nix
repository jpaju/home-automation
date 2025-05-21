{ config, pkgs, username, userhome, email, ... }: {
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

    openssh.authorizedKeys.keys =
      [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNCVK2DGtkXqX5eN+yGgBf7uDddLr89PCSYmIUhfobJ ${email}" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${userhome}/.config/sops/age/keys.txt"; # TODO User different filepath?

    secrets.cloudflare_api_token = { };
  };

  environment.systemPackages = with pkgs; [ git sops ];

  networking.hostName = "home-automation";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = let
      hass = 8123;
      ssh = 22;
      http = 80;
      https = 443;
    in [ ssh http https hass ];

    allowedUDPPorts = let
      ssdp = 1900;
      mdns = 5353;
    in [ ssdp mdns ];
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.AcceptEnv = "TERM COLORTERM";
  };

  security.acme = {
    acceptTerms = true;

    defaults = {
      inherit email;
      dnsProvider = "cloudflare";
      credentialFiles.CF_DNS_API_TOKEN_FILE = config.sops.secrets."cloudflare_api_token".path;
    };
  };

  services.nginx = {
    enable = true;

    virtualHosts = let
      dockerUrl = "http://docker.int.jpaju.fi";
      proxyTo = backendUrl: {
        locations."/" = {
          proxyPass = backendUrl;
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };

        # TODO Replace enableSSL with forceSSL?
        addSSL = true;
        enableACME = true;
        acmeRoot = null;
      };
    in {
      "hass.jpaju.fi" = proxyTo "${dockerUrl}:8123";
      "esphome.int.jpaju.fi" = proxyTo "${dockerUrl}:6052";
      "zigbee2mqtt.int.jpaju.fi" = proxyTo "${dockerUrl}:8080";
      "zwavejs.int.jpaju.fi" = proxyTo "${dockerUrl}:8091";
      "portainer.int.jpaju.fi" = proxyTo "${dockerUrl}:9000";
    };
  };

  virtualisation.docker.enable = true;

  systemd.services.home-automation = {
    enable = true;
    path = [ pkgs.docker ];
    requires = [ "docker.service" ];
    after = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      WorkingDirectory = "/etc/nixos";
      ExecStartPre = "${pkgs.docker}/bin/docker compose pull";
      ExecStart = "${pkgs.docker}/bin/docker compose up";
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

