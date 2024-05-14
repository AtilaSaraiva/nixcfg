{ pkgs, ... }:

{
  home.packages = [
    pkgs.feh
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/png" = "feh.desktop";
      "image/jpeg" = "feh.desktop";
    };
  };
}
