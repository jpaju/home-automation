{
  config,
  pkgs,
  username,
  ...
}:
let
  smbServer = "//jp-nas1.int.jpaju.fi";
  mountPoint = "/mnt/media";
  credentialsFile = config.sops.templates.smb-credentials.path;
in
{
  services.plex = {
    enable = true;
    user = username;
    dataDir = "/srv/plex";
  };

  # Mount NAS media as samba share
  fileSystems.${mountPoint} = {
    device = "${smbServer}/Media";
    fsType = "cifs";
    options = [
      "credentials=${credentialsFile}"
      "vers=3.0"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
    ];
  };

  # Create mount folder
  systemd.tmpfiles.settings."10-media".${mountPoint}.d = {
    user = "root";
    group = "wheel";
    mode = "0755";
  };

  # Required by samba mount
  environment.systemPackages = [ pkgs.cifs-utils ];
}
