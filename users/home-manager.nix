{
  home-manager,
  sops-nix,
  dotfiles,
  system,
  username,
  userhome,
  homeStateVersion,
  config,
  ...
}:
let
  fishUtils = import "${dotfiles}/util/fish.nix";

  specialArgs = {
    inherit
      home-manager
      sops-nix
      dotfiles
      system
      username
      userhome
      homeStateVersion
      fishUtils
      ;

    systemSops = config.sops;
    helix = dotfiles.inputs.helix;
    llm-agents = dotfiles.inputs.llm-agents.packages.${system};
    catppuccin = dotfiles.inputs.catppuccin;
  };
in
{
  imports = [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = specialArgs;
      home-manager.backupFileExtension = "bak";
      home-manager.users.${username} = {
        dotfiles = config.dotfiles;
        imports = [ ./home.nix ];
      };
    }
  ];

}
