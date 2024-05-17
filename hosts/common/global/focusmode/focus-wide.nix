{ lib, pkgs, config, ... }:

lib.mkIf (!config.focusMode) {
  environment.systemPackages = with pkgs; [
    # Social
    tdesktop
    jellyfin-media-player

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
}
