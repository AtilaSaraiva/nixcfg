{ pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    user = "atila";
    openFirewall = true;
    package = pkgs.jellyfin;
  };

  systemd.services.jellyfin.serviceConfig = {
    ProtectHome = true;
    ProtectSystem = true;
    NoNewPrivileges = true;
    ProtectKernelLogs = true;
    ProtectKernelTunables = true;
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
