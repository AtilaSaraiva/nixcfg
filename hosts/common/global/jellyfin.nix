{ pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    user = "atila";
    openFirewall = true;
    package = pkgs.jellyfin;
  };

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  services.bazarr = {
    enable = true;
    user = "atila";
  };
  services.sonarr = {
    enable = true;
    user = "atila";
  };
  services.jackett = {
    enable = true;
    user = "atila";
  };
}
