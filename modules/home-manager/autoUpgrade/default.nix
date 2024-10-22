{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.autoUpgrade;
in
{
  options.services.autoUpgrade = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable or disable the Julia precompilation scheduling.";
    };
    flake_output = mkOption {
      type = types.str;
      description = "The output of the flake, e.g., <flakepath>#<flake_output>.";
    };
    flake_path = mkOption {
      type = types.str;
      default = config.folders.nixcfg;
      description = "Path to the flake with the configuration.";
    };
    julia_env_path = mkOption {
      type = types.str;
      description = "Path to the Julia environments folder (typically ~/.julia).";
      default = "~/.julia/environments";
    };
    schedule = mkOption {
      type = types.str;
      description = "The OnCalendar value to control the service schedule (e.g., daily, weekly, or custom schedules).";
      default = "daily"; # Default schedule
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.autoUpgrade = {
      Unit.Description = "Home-manager auto upgrade";
      Service = {
        ExecStart = "${pkgs.nixosbuild}/bin/nixosbuild ${cfg.flake_path} ${cfg.flake_output} ${cfg.julia_env_path}";
        Restart = "on-failure";
      };
    };

    # Schedule the service based on the user's schedule preference
    systemd.user.timers.autoUpgrade = {
      Unit.Description = "Scheduled Julia Precompilation Timer";
      Timer = {
        OnCalendar = cfg.schedule;
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
