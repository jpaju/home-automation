{ pkgs, ... }: {
  networking.firewall = let
    mqtt = 1883;
    hass = 8123;
    ssdp = 1900;
    mdns = 5353;
    coap = 5683; # Shelly CoIoT
  in {
    allowedTCPPorts = [ hass mqtt ];
    allowedUDPPorts = [ ssdp mdns coap ];
  };

  systemd.tmpfiles.settings."10-hass" = {
    "/srv" = {
      d = {
        user = "root";
        group = "wheel";
        mode = "0774";
      };
    };
  };

  environment.systemPackages = [ pkgs.sqlite pkgs.lazysql ];

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.autoPrune.flags = [ "--all" ];

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
      ExecReload = "${pkgs.docker}/bin/docker compose up -d --remove-orphans";
      ExecStop = "${pkgs.docker}/bin/docker compose down";
      TimeoutStartSec = 0;
    };
  };
}
