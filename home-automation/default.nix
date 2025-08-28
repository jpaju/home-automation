{ ... }:
{
  imports = [
    ./nginx.nix
    ./home-assistant.nix
    ./music-assistant.nix
    ./backup.nix
  ];
}
