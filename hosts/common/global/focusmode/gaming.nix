{ lib, pkgs, config, inputs, ... }:

lib.mkIf (!config.focusMode && config.gaming.enable) {
  environment.systemPackages = with pkgs; [
    # Gaming
    vulkan-tools
    winetricks
    mangohud
    zeroad
    lutris
    rpcs3
    wine-wayland
    steam-run
    protontricks
    openmw
  ];

  # Special apps (requires more than their package to work).
  programs.steam = {
    enable = true;
    gamescopeSession = {
      enable = true; # Gamescope session is better for AAA gaming.
    };
  };
  programs.gamescope = {
    enable = true;
    capSysNice = false; # capSysNice freezes gamescopeSession for me.
    args = [ ];
    env = lib.mkForce {
      # I set DXVK_HDR in the alternative-sessions script.
      ENABLE_GAMESCOPE_WSI = "1";
    };
    package = pkgs.gamescope;
  };

  specialisation.jovian = {
    inheritParentConfig = false;
    configuration = {
      imports = [
        inputs.jovian-nixos.nixosModules.default
        ../defaults.nix
        ../flatpak.nix
        ../nix.nix
        ../../users/atila.nix
        config.gaming.hardwareConfiguration
      ];

      services.xserver.enable = true;
      services.xserver.desktopManager.gnome.enable = true;

      system.nixos.tags = [ "jovian" ];

      jovian = {
        steam = {
          enable = true;
          desktopSession = "gnome";
          user = "atila";
          autoStart = true;

        };
        hardware.has.amd.gpu = true;
        steamos = {
          useSteamOSConfig = true;
          enableSysctlConfig = true;
        };
      };

      environment.systemPackages = with pkgs; [
        # Gaming
        vulkan-tools
        winetricks
        mangohud
        zeroad
        lutris
        rpcs3
        wine-wayland
        steam-run
        protontricks
        openmw
      ];

      system.stateVersion = config.system.stateVersion;

      # TODO: Set your hostname
      networking.hostName = config.networking.hostName;

      # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
      i18n.defaultLocale = config.i18n.defaultLocale;

      time.timeZone = config.time.timeZone;
    };
  };
}
