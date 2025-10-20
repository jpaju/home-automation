{ ... }:
{
  imports = [
    ./nginx.nix
    ./home-assistant.nix
    ./backup.nix
  ];
}
