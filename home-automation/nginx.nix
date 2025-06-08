{ config, ... }: {
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;

    virtualHosts = let
      dockerUrl = "http://home-automation.int.jpaju.fi";
      proxyTo = { backendUrl, allowInternetAccess ? false }: {
        locations."/" = {
          proxyPass = backendUrl;
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };

        forceSSL = true;
        enableACME = true;
        acmeRoot = null;

        extraConfig = if allowInternetAccess then
          ""
        else ''
          allow 192.168.0.0/16;
          allow 10.0.0.0/8;
          allow 172.16.0.0/12;
          deny all;
        '';
      };
    in {
      "hass.jpaju.fi" = proxyTo {
        backendUrl = "${dockerUrl}:8123";
        allowInternetAccess = true;
      };
      "esphome.int.jpaju.fi" = proxyTo { backendUrl = "${dockerUrl}:6052"; };
      "zigbee2mqtt.int.jpaju.fi" = proxyTo { backendUrl = "${dockerUrl}:8080"; };
      "zwavejs.int.jpaju.fi" = proxyTo { backendUrl = "${dockerUrl}:8091"; };
      "portainer.int.jpaju.fi" = proxyTo { backendUrl = "${dockerUrl}:9000"; };
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
