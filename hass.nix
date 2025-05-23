{ pkgs, ... }: {
  networking.firewall = {
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
}
