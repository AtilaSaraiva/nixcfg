{ pkgs, ... }:

let
  SUNSHINE_CLIENT_WIDTH = "3840";
  SUNSHINE_CLIENT_HEIGHT = "2160";
  SUNSHINE_CLIENT_FPS = "60.000";
in
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;

    settings = {
      sunshine_name = "nixos";
      port = 47990;
      capture = "wlr";
    };

    applications = {
      env = {
        # PATH = "$(PATH):$(HOME)/.local/bin";
      };
      apps = [
        {
          name = "0ad";
          cmd = "/run/current-system/sw/bin/0ad";
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "Steam";
          do = ''
            /run/current-system/sw/bin/sh -c "/home/atila/.nix-profile/bin/swaymsg output HEADLESS-1 enable; /home/atila/.nix-profile/bin/swaymsg output HEADLESS-1 mode ${SUNSHINE_CLIENT_WIDTH}x${SUNSHINE_CLIENT_HEIGHT}@${SUNSHINE_CLIENT_FPS}Hz" && /home/atila/.nix-profile/bin/swaymsg output DP-2 disable
          '';
          cmd = ''
            /run/current-system/sw/bin/steam steam://open/gamepadui
          '';
          undo = ''
            /home/atila/.nix-profile/bin/swaymsg output HEADLESS-1 disable && /home/atila/.nix-profile/bin/swaymsg output DP-2 enable
          '';
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
      ];
    };
  };
}
