{ pkgs, ... }: {
  networking.firewall = let
    hass = 8123;
    ssdp = 1900;
    mdns = 5353;
    coap = 5683; # Shelly CoIoT
  in {
    allowedTCPPorts = [ hass ];
    allowedUDPPorts = [ ssdp mdns coap ];
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
      WorkingDirectory = "/etc/nixos/home-automation";
      ExecStart = "${pkgs.docker}/bin/docker compose up -d --remove-orphans";
      ExecReload = "${pkgs.docker}/bin/docker compose up -d";
      ExecStop = "${pkgs.docker}/bin/docker compose down";
      TimeoutStartSec = 0;
    };
  };
}
