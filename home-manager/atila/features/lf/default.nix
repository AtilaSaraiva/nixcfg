{ pkgs, ... }:

{
  xdg.configFile."lf/lfrc".source = ./lfrc;
  xdg.configFile."lf/lf_kitty_clean".source = ./lf_kitty_clean;
  xdg.configFile."lf/lf_kitty_preview".source = ./lf_kitty_preview;

  home.packages = [
    pkgs.lf
  ];
}
