{
  description = "My NixOS configuration as a flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:jpaju/dotfiles/expose-nix-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, sops-nix, dotfiles, ... }:
    let
      system = "x86_64-linux";

      username = "jaakko";
      userhome = "/home/${username}";
      email = "jaakko.paju2@gmail.com";

      specialArgs = {
        inherit home-manager sops-nix dotfiles;
        inherit system username userhome email;

        fishUtils = dotfiles.homeManagerModules.fishUtils;
        scls = dotfiles.inputs.scls;
        helix = dotfiles.inputs.helix;
      };
    in {
      nixosConfigurations.home-automation = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;

        modules = [
          ./configuration.nix
          ./hardware-configuration.nix

          sops-nix.nixosModules.sops

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };
    };
}

