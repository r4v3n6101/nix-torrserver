{
  lib,
  config,
  ...
}:
let
  cfg = config.services.torrserver // { };

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
    environment.systemPackages = [ cfg.package ];

    launchd.daemons.torrserver = {
      serviceConfig = {
        ProgramArguments = [ "${cfg.package}/bin/torrserver" ] ++ args;
        RunAtLoad = true;
        KeepAlive = true;
        WorkingDirectory = cfg.workingDir;
        StandardOutPath = "/var/log/torrserver/stdout.log";
        StandardErrorPath = "/var/log/torrserver/stderr.log";
      };
    };

    system.activationScripts.preActivation.text = ''
      mkdir -p ${cfg.workingDir}
    '';
  };
}
