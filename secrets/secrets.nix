{ pkgs, sops-nix, userhome, ... }: {
  imports = [ sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${userhome}/.config/sops/age/keys.txt"; # TODO User different filepath?

    secrets.cloudflare_api_token = { };
    secrets."restic/repository/password" = { };
    secrets."restic/nas/username" = { };
    secrets."restic/nas/password" = { };
  };

  environment.systemPackages = with pkgs; [ git sops ];
}
