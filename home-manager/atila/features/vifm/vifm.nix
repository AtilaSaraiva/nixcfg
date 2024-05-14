{ pkgs, ... }:

{
  xdg.configFile."vifm/vifmrc".source = ./vifmrc;

  home.packages = [
    pkgs.vifm
  ];
}
