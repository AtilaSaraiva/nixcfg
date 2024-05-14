{ pkgs, ... }:

{
  xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;

  home.packages = [
    pkgs.kitty
  ];
}
