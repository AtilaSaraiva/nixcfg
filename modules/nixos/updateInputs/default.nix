{ config, lib, pkgs, outputs, ... }:

with lib;

let
  cfg = config.services.updateInputs;
in
{
  options.services.updateInputs = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable or disable the automated nix rebuild script.";
    };
    schedule = mkOption {
      type = types.str;
      default = "daily"; # Default schedule
      description = "The OnCalendar value to control the service schedule (e.g., daily, weekly, or custom).";
    };
    flake_path = mkOption {
      type = types.str;
      description = "The path to the flake configuration.";
    };
    user = mkOption {
      type = types.str;
      default = "atila";
      description = ''
        User account under which the service runs.
      '';
    };
    group = mkOption {
      type = types.str;
      default = "users";
      description = ''
        Group under which qBittorrent runs.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.updateInputs = {
      description = "Automated Nix Rebuild Script";

      path = with pkgs; [
        git
        libnotify
      ];

      script = ''
        #!/usr/bin/env bash

        # Define the NIXCFG folder and list of hostnames
        NIXCFG=${cfg.flake_path}
        HOSTNAMES=${builtins.toString (builtins.attrNames outputs.homeConfigurations)}

        # cd into the NIXCFG folder
        cd "$NIXCFG" || { echo "Failed to cd into $NIXCFG"; exit 1; }

        # Create a new branch with a random 6-char key
        BRANCH_NAME="update-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 6)"
        git checkout -b "$BRANCH_NAME"

        # Run nix flake update
        nix flake update
        if [ $? -ne 0 ]; then
            notify-send "Flake update failed."
            exit 1
        fi

        # Run nixos-rebuild and home-manager for each hostname
        for HOSTNAME in $HOSTNAMES; do
            nixos-rebuild build --flake .#"$HOSTNAME"
            if [ $? -ne 0 ]; then
                notify-send "nixos-rebuild failed for $HOSTNAME."
                exit 1
            fi

            home-manager build --flake .#"atila@$HOSTNAME"
            if [ $? -ne 0 ]; then
                notify-send "home-manager build failed for atila@$HOSTNAME."
                exit 1
            fi
        done

        # If all builds pass, commit the updated flake and merge to main
        git add flake.lock
        git commit -m "Update flake and rebuild for hosts: $(HOSTNAMES)"
        git checkout main
        git merge "$BRANCH_NAME"

        # Push changes
        git push origin main

        # Send notification for success
        notify-send "Update and rebuild completed successfully."
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
      };

      startAt = cfg.schedule;

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };

    systemd.user.timers.updateInputs = {
      description = "Scheduled Nix Rebuild Timer";
      timerConfig = {
        Persistent = true;
      };
    };
  };
}
