{ pkgs, ... }:

{
  xdg.configFile."zathura/zathurarc".source = ./zathurarc;

  home.packages = [
    pkgs.zathura
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "application/epub+zip" = "org.pwmt.zathura.desktop";
    };
  };
}
