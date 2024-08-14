{ config, pkgs, ... }:

{
  xdg.configFile."qutebrowser/autoconfig.yml".source = ./autoconfig.yml;
  xdg.configFile."qutebrowser/quickmarks".source = ./quickmarks;
  xdg.configFile."qutebrowser/bookmarks/urls".source = ./bookmarks/urls;

  home.packages = [
    pkgs.qutebrowser
  ];

  xdg.mimeApps = {
    enable=true;
    defaultApplications = {
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "application/x-extension-htm"="org.qutebrowser.qutebrowser.desktop";
      "application/x-extension-html"="org.qutebrowser.qutebrowser.desktop";
      "application/x-extension-shtml"="org.qutebrowser.qutebrowser.desktop";
      "application/xhtml+xml"="org.qutebrowser.qutebrowser.desktop";
      "application/x-extension-xhtml"="org.qutebrowser.qutebrowser.desktop";
      "application/x-extension-xht"="org.qutebrowser.qutebrowser.desktop";
    };
  };
}
