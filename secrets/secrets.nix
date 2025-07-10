{ pkgs, sops-nix, userhome, username, ... }: {
  imports = [ sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${userhome}/.config/sops/age/keys.txt"; # TODO User different filepath?

    secrets.anthropic_api_key = { owner = username; };
    secrets.cloudflare_api_token = { };
    secrets.restic_repository_password = { };
  };

  environment.systemPackages = with pkgs; [ git sops ];
}
