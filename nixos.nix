{
  lib,
  config,
  ...
}:
let
  cfg = config.services.torrserver;

  boolFlag = name: cliName: lib.optional (cfg.${name} or false) cliName;

  optFlag = name: cliName: lib.optional (cfg.${name} != null) "${cliName}=${toString cfg.${name}}";

  args =
    [ ]
    ++ optFlag "port" "--port"
    ++ optFlag "ip" "--ip"
    ++ boolFlag "ssl" "--ssl"
    ++ optFlag "sslPort" "--sslport"
    ++ optFlag "sslCert" "--sslcert"
    ++ optFlag "sslKey" "--sslkey"
    ++ optFlag "dataDir" "--path"
    ++ optFlag "logPath" "--logpath"
    ++ optFlag "webLogPath" "--weblogpath"
    ++ boolFlag "readOnlyDb" "--rdb"
    ++ boolFlag "httpAuth" "--httpauth"
    ++ boolFlag "dontKill" "--dontkill"
    ++ optFlag "torrentsDir" "--torrentsdir"
    ++ optFlag "torrentAddr" "--torrentaddr"
    ++ optFlag "publicIPv4" "--pubipv4"
    ++ optFlag "publicIPv6" "--pubipv6"
    ++ boolFlag "allowSearchWithoutAuth" "--searchwa"
    ++ optFlag "maxStreamSize" "--maxsize"
    ++ optFlag "telegramToken" "--tg";
in
{
  config = lib.mkIf cfg.enable {
    systemd.services.torrserver = {
      description = "TorrServer";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/torrserver ${lib.concatStringsSep " " args}";
        WorkingDirectory = cfg.workingDir;

        StateDirectory = "torrserver";
        StateDirectoryMode = "0755";

        Restart = "on-failure";
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };
  };
}
