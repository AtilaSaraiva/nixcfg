{
  xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;

  programs.kitty.enable = true;

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "x-scheme-handler/terminal" = "kitty.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/terminal" = "kitty.desktop";
      "inode/mount-point" = "kitty-open.desktop";
      "inode/directory" = "kitty-open.desktop";
    };
  };
}
