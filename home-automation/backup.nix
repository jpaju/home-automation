{ config, ... }:
let
  repository = "sftp:home-automation@jp-nas1.int.jpaju.fi:/Backupit/home-automation";
  passwordFile = config.sops.secrets."restic/repository/password".path;

  esphome = {
    include = "/srv/esphome";
    exclude = [
      "/srv/esphome/config/.esphome/build"
      "/srv/esphome/config/.esphome/external_components"
      "/srv/esphome/config/.esphome/file"
      "/srv/esphome/config/.esphome/idedata"
      "/srv/esphome/config/.esphome/idf_components"
      "/srv/esphome/config/.esphome/packages"
      "/srv/esphome/config/.esphome/platformio"
    ];
  };
  home-assistant = {
    include = "/srv/home-assistant";
    exclude = [
      "/srv/home-assistant/config/backups"
      "/srv/home-assistant/config/custom_components"
      "/srv/home-assistant/config/tts"
    ];
  };
  mosquitto = {
    include = "/srv/mosquitto";
    exclude = [ "/srv/mosquitto/log/mosquitto.log" ];
  };
  portainer = {
    include = "/srv/portainer";
    exclude = [ "/srv/portainer/bin" ];
  };
  zigbee2mqtt = {
    include = "/srv/zigbee2mqtt";
    exclude = [ "/srv/zigbee2mqtt/data/log" ];
  };
  zwavejs = {
    include = "/srv/zwavejs";
    exclude = [ "/srv/zwavejs/logs" "/srv/zwavejs/.config-db" "/srv/zwavejs/*.lock" ];
  };
in {
  services.restic.backups.home-automation = {
    inherit repository passwordFile;

    # TODO Notification if backup fails

    initialize = true;
    createWrapper = true;
    runCheck = true;

    extraBackupArgs = [ "--verbose" ];

    timerConfig = {
      OnCalendar = "21:40";
      Persistent = true;
    };

    pruneOpts = [ # Newline
      "--keep-daily 30"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 5"
    ];

    paths = [
      esphome.include
      home-assistant.include
      mosquitto.include
      portainer.include
      zigbee2mqtt.include
      zwavejs.include
    ];

    exclude = esphome.exclude ++ home-assistant.exclude ++ mosquitto.exclude ++ portainer.exclude ++ zigbee2mqtt.exclude
      ++ zwavejs.exclude;
  };
}
