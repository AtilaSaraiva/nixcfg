{ pkgs, ... }:

{
  xdg.configFile."mpv/mpv.conf".source = ./mpv.conf;

  home.packages = [
    pkgs.mpv
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "video/x-matroska" = "mpv.desktop";
    };
  };
}
