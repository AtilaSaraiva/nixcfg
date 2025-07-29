{ pkgs, ... }:

{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;

    settings = {
      sunshine_name = "nixos";
      port = 47990;
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
          cmd = "/run/current-system/sw/bin/steam steam://open/gamepadui";
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
      ];
    };
  };
}
