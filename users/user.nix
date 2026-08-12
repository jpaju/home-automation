{ pkgs, username, ... }:
{
  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.fish;
  };

}
