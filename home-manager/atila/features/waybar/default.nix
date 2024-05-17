{ pkgs, ... }:

{
  xdg.configFile."waybar/config".source = ./config;
  xdg.configFile."waybar/style.css".source = ./style.css;
  xdg.configFile."waybar/menuicon.png".source = ./menuicon.png;
}
