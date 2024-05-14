{ pkgs, ... }:

{
  xdg.configFile."mpv/mpv.conf".source = ./mpv.conf;

  home.packages = [
    pkgs.mpv
  ];
}
