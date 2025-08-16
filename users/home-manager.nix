{
  system,
  home-manager,
  sops-nix,
  dotfiles,
  username,
  userhome,
  config,
  ...
}:
let
  specialArgs = {
    inherit home-manager sops-nix dotfiles;
    inherit system username userhome;
    systemSops = config.sops;

    fishUtils = dotfiles.homeModules.fishUtils;
    helix = dotfiles.inputs.helix;
  };
in
{
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
