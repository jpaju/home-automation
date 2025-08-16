{ ... }:
{
  imports = [
    ./nginx.nix
    ./hass.nix
    ./backup.nix
  ];
}
