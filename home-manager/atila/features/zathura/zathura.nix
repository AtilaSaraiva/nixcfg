{ pkgs, ... }:

{
  xdg.configFile."zathura/zathurarc".source = ./zathurarc;

  home.packages = [
    pkgs.zathura
  ];
}
