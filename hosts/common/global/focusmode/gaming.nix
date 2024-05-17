{ lib, pkgs, config, inputs, ... }:

lib.mkIf (!config.focusMode && config.gaming) {
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
        ../zram.nix
        ../nix.nix
        ../../users/atila.nix
        ../../../igris/hardware-configuration.nix
      ];

      #services.xserver.enable = true;
      #services.xserver.desktopManager.gnome.enable = true;

      system.nixos.tag = [ "jovian" ];

      jovian = {
        steam = {
          enable = true;
          #desktopSession = "gnome";
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
    };
  };
}
