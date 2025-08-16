{ username, ... }:
{
  networking.firewall.allowedTCPPorts = [ 22 ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.AcceptEnv = "TERM COLORTERM";
  };

  users.users."${username}".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNCVK2DGtkXqX5eN+yGgBf7uDddLr89PCSYmIUhfobJ jaakko-macbook"
  ];
}
