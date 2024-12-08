{ lib, config, pkgs, ... }:

let
  fullDeviceList = [
    "igris"
    "betinha"
  ];
  cfg = config.services.bukusync;
in
{
  options.services.bukusync = {
    enable = lib.mkEnableOption "Sync engine for buku files on different computers";
    schedule = lib.mkOption {
      type = lib.types.str;
      default = "daily"; # Default schedule
      description = "The OnCalendar value to control the service schedule (e.g., daily, weekly, or custom).";
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.user.timers = {
      bukusync = {
        Unit.Description = "synchronize buku files from different systems";
        Timer = {
          Unit = "bukusync";
          OnBootSec = "5m";
          OnUnitActiveSec = "1m";
          OnCalendar = cfg.schedule;
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };

    systemd.user.services = {
      bukusync = {
        Unit = {
          Description = "buku syncrhonization timer";
        };
        Service = {
          Type = "oneshot";
          ExecStart = toString (
            pkgs.writeShellScript "bukusync-script" ''
              set -eu

              cd tmp
              for client in ${builtins.toString fullDeviceList}; do
                echo "doing sync for $client"
                ${pkgs.openssh}/bin/scp $client:.local/share/buku/bookmarks.db $client-bookmarks.db
                ${pkgs.buku}/bin/buku --nostdin --import $client-bookmarks.db
                ${pkgs.coreutils}/bin/rm $client-bookmarks.db
              done
              for client in ${builtins.toString fullDeviceList}; do
                ${pkgs.openssh}/bin/scp ../.local/share/buku/bookmarks.db $client:.local/share/buku/bookmarks.db
              done
            ''
          );
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
  };
}
