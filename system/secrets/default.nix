{
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

    secrets.anthropic_api_key.owner = username;
    secrets.openai_api_key.owner = username;
    secrets.google_generative_ai_api_key.owner = username;
    secrets.context7_api_key.owner = username;

    secrets.cloudflare_api_token = { };
    secrets.restic_repository_password = { };
    secrets."hass.env" = { };
    secrets."esphome.env" = { };
  };

  environment.systemPackages = with pkgs; [
    git
    sops
  ];
}
