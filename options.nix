{
  lib,
  torrserver,
  ...
}:
with lib;
{
  options.services.torrserver = {
    enable = mkEnableOption "Enable TorrServer service";

    package = mkOption {
      type = types.package;
      default = torrserver;
      description = "TorrServer package to run";
    };

    port = mkOption {
      type = types.port;
      default = 8090;
      description = "Web server HTTP port";
    };

    ip = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Web server bind address. Null binds to all interfaces";
    };

    ssl = mkOption {
      type = types.bool;
      default = false;
      description = "Enable HTTPS for web server";
    };

    sslPort = mkOption {
      type = types.nullOr types.port;
      default = null;
      description = "HTTPS port. Null uses previous DB value or default 8091";
    };

    sslCert = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "SSL certificate path. Null generates self-signed cert";
    };

    sslKey = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "SSL key path. Null generates self-signed key";
    };

    dataDir = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Database and configuration directory path";
    };

    workingDir = mkOption {
      type = types.path;
      default = "/var/lib/torrserver";
      description = "Working directory for TorrServer";
    };

    logPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Server log file path";
    };

    webLogPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Web access log file path";
    };

    readOnlyDb = mkOption {
      type = types.bool;
      default = false;
      description = "Start server in read-only database mode";
    };

    httpAuth = mkOption {
      type = types.bool;
      default = false;
      description = "Enable HTTP authentication on all requests";
    };

    dontKill = mkOption {
      type = types.bool;
      default = false;
      description = "Do not terminate server on signal";
    };

    torrentsDir = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Directory to auto-load torrent files from";
    };

    torrentAddr = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Torrent client address ([IP]:PORT)";
    };

    publicIPv4 = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Public IPv4 address";
    };

    publicIPv6 = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Public IPv6 address";
    };

    allowSearchWithoutAuth = mkOption {
      type = types.bool;
      default = false;
      description = "Allow search without authentication";
    };

    maxStreamSize = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "Maximum allowed stream size in bytes";
    };

    telegramToken = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Telegram bot token";
    };
  };
}
