{ system, home-manager, sops-nix, dotfiles, username, userhome, ... }:
let
  specialArgs = {
    inherit home-manager sops-nix dotfiles;
    inherit system username userhome;

    fishUtils = dotfiles.homeManagerModules.fishUtils;
    scls = dotfiles.inputs.scls;
    helix = dotfiles.inputs.helix;
  };
in {
  imports = [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = specialArgs;
      home-manager.users.${username} = import ./home.nix;
    }
  ];

}

