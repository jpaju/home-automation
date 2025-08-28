{ ... }:
{
  networking.firewall =
    let
      musicAssistantServer = 8097;
      mdns = 5353;
      upnpDiscovery = 1900;
      rtsp = 554; # AirPlay Real Time Streaming Protocol
      daap = 3689; # AirPlay Digital Audio Access Protocol
      raop = [
        # Remote Audio Output Protocol
        5000
        5001
      ];
      airplayTimeSync = [
        7010
        7011
      ];
      airplayAudio = {
        from = 6001;
        to = 6012;
      };
      airplayMirroring = {
        from = 49152;
        to = 65535;
      };
    in
    {
      allowedTCPPorts = raop ++ [
        daap
        musicAssistantServer
        rtsp
      ];
      allowedUDPPorts = airplayTimeSync ++ [
        upnpDiscovery
        mdns
        rtsp
      ];

      allowedTCPPortRanges = [ airplayMirroring ];
      allowedUDPPortRanges = [
        airplayMirroring
        airplayAudio
      ];
    };

}
