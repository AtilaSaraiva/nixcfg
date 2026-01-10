{ lib, pkgs, config, ... }:

lib.mkIf (!config.focusMode) {
  environment.systemPackages = with pkgs; [
    # Social
    telegram-desktop
    jellyfin-media-player
  ];
}
