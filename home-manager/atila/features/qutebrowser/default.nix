{ config, pkgs, ... }:

let
  dotfiles = config.lib.file.mkOutOfStoreSymlink ./.;
in
{
  #options = {
    #dotfilesPath = lib.mkOption {
      #type = lib.types.pat
    #};
  #};
  xdg.configFile."qutebrowser/autoconfig.yml".source = "${dotfiles}/autoconfig.yml";
  xdg.configFile."qutebrowser/quickmarks".source = "${dotfiles}/quickmarks";
  xdg.configFile."qutebrowser/bookmarks/urls".source = "${dotfiles}/bookmarks/urls";

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
