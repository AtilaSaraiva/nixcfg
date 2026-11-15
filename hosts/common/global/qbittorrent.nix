{
  config,
  lib,
  pkgs,
  ...
}: {
  # nixpkgs' qbittorrent module. Profile lives in
  # /var/lib/qBittorrent/qBittorrent/{config,data}; the module runs it with
  # ProtectHome=yes, so nothing under /home is reachable.
  services.qbittorrent = {
    enable = true;
    package = pkgs.stable.qbittorrent-nox; # 5.3.x is rejected by a private tracker
    # Same user as jellyfin/sonarr/bazarr/jackett, and the owner of /mnt/storage.
    user = "atila";
    group = "users";
    webuiPort = 35910;

    # Fully declarative: qBittorrent.conf is regenerated from this on every
    # start, so changes made in the Web UI are lost on restart unless copied
    # here. Categories (categories.json) and per-torrent tags/categories
    # (BT_backup/*.fastresume) are separate files and are not touched.
    serverConfig = let
      profile = config.services.qbittorrent.profileDir;
    in {
      LegalNotice.Accepted = true;
      # Last migration run by 5.1.4; without it qBittorrent would re-run its
      # config migrations on every start.
      Meta.MigrationVersion = 8;

      Application = {
        MemoryWorkingSetLimit = 30000;
        FileLogger = {
          Enabled = true;
          Path = "${profile}/qBittorrent/data/logs";
          Backup = true;
          DeleteOld = true;
          Age = 1;
          AgeType = 1;
          MaxSizeBytes = 66560;
        };
      };

      Core.AutoDeleteAddedTorrentFile = "IfAdded";

      BitTorrent.Session = {
        DefaultSavePath = "/mnt/storage/downloads/torrenting";
        InterfaceAddress = "10.0.0.165";
        Port = 16770;
        SSL.Port = 18849;
        DHTEnabled = false;
        AddTorrentStopped = false;
        DisableAutoTMMByDefault = false;
        DisableAutoTMMTriggers = {
          CategorySavePathChanged = false;
          DefaultSavePathChanged = false;
        };
        DiskIOType = "Posix";
        GlobalUPSpeedLimit = 1000;
        UseAlternativeGlobalSpeedLimit = false;
        QueueingSystemEnabled = false;
        IgnoreSlowTorrentsForQueueing = true;
        SlowTorrentsDownloadRate = 30;
        SlowTorrentsUploadRate = 30;
        MaxActiveCheckingTorrents = 3;
        MaxActiveDownloads = 200;
        MaxActiveTorrents = 10000;
        MaxActiveUploads = 10;
        MaxConnections = 10000;
        MaxConnectionsPerTorrent = 200;
        MaxUploads = -1;
        ProxyPeerConnections = false;
        ShareLimitAction = "Stop";
        # The tag list itself lives here, so a tag created in the Web UI
        # disappears from the list on restart unless it is added below.
        Tags = lib.concatStringsSep ", " [
          "aither" "ant" "bitp" "blu" "cross-seed" "fitgirl"
          "ipt" "mouse" "nbl" "orpheus" "pixelcove" "toKeep"
        ];
      };

      Network = {
        PortForwardingEnabled = true;
        Proxy.Type = "None";
      };

      Preferences = {
        General.Locale = "en";
        Connection = {
          ResolvePeerCountries = true;
          ResolvePeerHostNames = false;
        };
        Advanced.RecheckOnCompletion = false;
      };

      RSS.Session.EnableProcessing = true;

      WebUI = {
        Enabled = true;
        Address = "*";
        Port = 35910;
        Username = "atila";
        # Password_PBKDF2 is injected from /secrets at start; see below.
        LocalHostAuth = false;
        AuthSubnetWhitelistEnabled = true;
        BanDuration = 3600;
        MaxAuthenticationFailCount = 5;
        SessionTimeout = 3600;
        CSRFProtection = true;
        ClickjackingProtection = true;
        HostHeaderValidation = true;
        SecureCookie = true;
        ServerDomains = "*";
        UseUPnP = true;
        HTTPS.Enabled = false;
        ReverseProxySupportEnabled = false;
        AlternativeUIEnabled = false;
        RootFolder = "${profile}/webui/qbtmud";
      };
    };
  };

  systemd.services.qbittorrent.serviceConfig = {
    # Kept from the old module: files created stay group-writable.
    UMask = "0002";

    # The Web UI password hash stays out of the repo and the Nix store. The
    # file holds the full value, quotes included: "@ByteArray(salt:hash)".
    # systemd reads it as root and exposes it only to this service.
    LoadCredential = [ "webui-password:/secrets/qbittorrent-webui-password.txt" ];

    # Runs after the module's step that installs the generated
    # qBittorrent.conf, adding the password to its [WebUI] section.
    ExecStartPre = lib.mkAfter [
      (pkgs.writeShellScript "qbittorrent-inject-password" ''
        set -eu
        conf="${config.services.qbittorrent.profileDir}/qBittorrent/config/qBittorrent.conf"
        hash="$(< "$CREDENTIALS_DIRECTORY/webui-password")"
        [ -n "$hash" ] || { echo "webui-password credential is empty" >&2; exit 1; }
        ${pkgs.gnused}/bin/sed -i "/^\[WebUI\]$/a Password_PBKDF2=$hash" "$conf"
      '')
    ];
  };
}
