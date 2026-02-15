{ pkgs, ... }:
{
  networking.firewall =
    let
      mqtt = 1883;
      hass = 8123;
      ssdp = 1900;
      mdns = 5353;
      coap = 5683; # Shelly CoIoT
      zoneConfigurator = 8099;
      zoneConfiguratorFirmwareProxy = 38080;
    in
    {
      allowedTCPPorts = [
        hass
        mqtt
        zoneConfigurator
        zoneConfiguratorFirmwareProxy
      ];
      allowedUDPPorts = [
        ssdp
        mdns
        coap
      ];
    };

  systemd.tmpfiles.settings."10-hass"."/srv".d = {
    user = "root";
    group = "wheel";
    mode = "0774";
  };

  environment.systemPackages = [
    pkgs.sqlite
    pkgs.lazysql
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.autoPrune.flags = [
    "--all"
    "--filter"
    "until=720h" # 1 week
  ];

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
