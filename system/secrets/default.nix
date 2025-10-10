{
  config,
  pkgs,
  sops-nix,
  username,
  ...
}:
{
  imports = [ sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/etc/sops/age/keys.txt";

    secrets.anthropic_api_key = {
      owner = username;
    };
    secrets.cloudflare_api_token = { };
    secrets.restic_repository_password = { };
    secrets."hass.env" = { };

    secrets.smb_username = { };
    secrets.smb_password = { };
    templates.smb-credentials.content = ''
      username=${config.sops.placeholder.smb_username}
      password=${config.sops.placeholder.smb_password}
    '';
  };

  environment.systemPackages = with pkgs; [
    git
    sops
  ];
}
