{ config, lib, ... }:
{
  networking.firewall.allowedTCPPorts = [
    80
    443
    63719
  ];

  services.nginx = {
    enable = true;

    virtualHosts =
      let
        externalDomain = "jpaju.fi";
        internalDomain = "int.jpaju.fi";
        dockerUrl = "http://home-automation.${internalDomain}";

        proxyTo =
          {
            backendUrl,
            allowInternetAccess ? false,
            port ? null,
          }:
          {
            locations."/" = {
              proxyPass = backendUrl;
              proxyWebsockets = true;
              recommendedProxySettings = true;
            };

            listen = lib.optionals (port != null) [
              {
                addr = "0.0.0.0";
                port = port;
                ssl = true;
              }
            ];

            forceSSL = true;
            enableACME = true;
            acmeRoot = null;

            extraConfig =
              if allowInternetAccess then
                ""
              else
                ''
                  allow 192.168.0.0/16;
                  allow 10.0.0.0/8;
                  allow 172.16.0.0/12;
                  deny all;
                '';
          };
      in
      {
        "hass.${externalDomain}" = proxyTo {
          port = 63719;
          backendUrl = "${dockerUrl}:8123";
          allowInternetAccess = true;
        };
        "music-assistant.${internalDomain}" = proxyTo { backendUrl = "${dockerUrl}:8095"; };
        "esphome.${internalDomain}" = proxyTo { backendUrl = "${dockerUrl}:6052"; };
        "zigbee2mqtt.${internalDomain}" = proxyTo { backendUrl = "${dockerUrl}:8080"; };
        "zwavejs.${internalDomain}" = proxyTo { backendUrl = "${dockerUrl}:8091"; };
        "portainer.${internalDomain}" = proxyTo { backendUrl = "${dockerUrl}:9000"; };
        "matter.${internalDomain}" = proxyTo { backendUrl = "${dockerUrl}:5580"; };
        "zone-configurator.${internalDomain}" = proxyTo { backendUrl = "${dockerUrl}:8099"; };
      };
  };

  security.acme = {
    acceptTerms = true;

    defaults = {
      email = "jpaju.admin+acme@icloud.com";
      dnsProvider = "cloudflare";
      credentialFiles.CF_DNS_API_TOKEN_FILE = config.sops.secrets."cloudflare_api_token".path;
    };
  };
}
