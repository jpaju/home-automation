{
  description = "NixOS configuration for home automation with Home Assistant";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:jpaju/dotfiles/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, sops-nix, dotfiles, ... }:
    let
      system = "x86_64-linux";
      username = "jaakko";
      userhome = "/home/${username}";

      specialArgs = {
        inherit home-manager sops-nix dotfiles;
        inherit system username userhome;
      };
    in {
      nixosConfigurations.home-automation = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;

        modules = [ # Newline
          ./system
          ./users
          ./secrets
          ./home-automation
        ];
      };
    };
}

