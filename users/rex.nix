{ inputs, username, ... }:
{
  users.users.${username}.linger = true;

  home-manager.users.${username} = {
    imports = [ inputs.rex.homeManagerModules.default ];
    services.rex.enable = true;
  };
}
