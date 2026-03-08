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
    gamemode
    vesktop # alternate client for discord
  ];

  # Special apps (requires more than their package to work).
  programs.steam = {
    enable = true;
    gamescopeSession = {
      enable = true; # Gamescope session is better for AAA gaming.
      args = [
        "--adaptive-sync"
        "--rt"
        "--mangoapp"
      ];
    };
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true; # capSysNice freezes gamescopeSession for me.
    args = [ ];
    env = lib.mkForce {
      # I set DXVK_HDR in the alternative-sessions script.
      ENABLE_GAMESCOPE_WSI = "1";
    };
    package = pkgs.gamescope;
  };

  environment.variables.WINE_FULLSCREEN_FSR = "1";

  hardware.steam-hardware.enable = true;
}
