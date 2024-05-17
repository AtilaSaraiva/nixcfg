{ lib, pkgs, config, ... }:

lib.mkIf (!config.focusMode) {
  environment.systemPackages = with pkgs; [
    # Social
    tdesktop
    jellyfin-media-player
  ];
}
