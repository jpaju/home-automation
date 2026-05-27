{
  system,
  inputs,
  username,
  userhome,
  homeStateVersion,
  config,
  ...
}:
let
  # Dotfiles home modules reference `inputs.<name>` for transitive flake inputs (helix, llm-agents, catppuccin, etc.)
  # that this flake does not declare at the top level. Merge them in so the modules can resolve them via `inputs`.
  homeInputs = inputs // inputs.dotfiles.inputs;

  specialArgs = {
    inputs = homeInputs;
    inherit
      system
      username
      userhome
      homeStateVersion
      ;

    systemSops = config.sops;

    fishUtils = import "${inputs.dotfiles}/util/fish.nix";
  };
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
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
