{ config, email, ... }: {
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;

    virtualHosts = let
      dockerUrl = "http://home-automation.int.jpaju.fi";
      proxyTo = backendUrl: {
        locations."/" = {
          proxyPass = backendUrl;
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };

        forceSSL = true;
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

  security.acme = {
    acceptTerms = true;

    defaults = {
      inherit email;
      dnsProvider = "cloudflare";
      credentialFiles.CF_DNS_API_TOKEN_FILE = config.sops.secrets."cloudflare_api_token".path;
    };
  };
}
