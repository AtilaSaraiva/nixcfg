{ pkgs, ... }:

{
  #wayland.windowManager.sway = {
    #enable = true;
    #wrapperFeatures.gtk = true;
  #};

  #wayland.windowManager.sway.systemd.enable = true;

  xdg.configFile."sway/config".source = ./config;


  home.packages = with pkgs; [
    aftergameopen
    animatedWallpaper
    bookmarkadd
    energyPlan
    i3empty
    kill4game
    oguriWallpaper
    pmenu_g
    portSwitch
    remote
    sway-display-swap
    toggleFreesync
  ];

  #home.packages = with pkgs; [
    #swaylock-effects
    #xwayland
    #swayidle
    #swaytools
    #wf-recorder
    #wl-clipboard
    #sway-contrib.grimshot
    #mako # notification daemon
    #kitty # Alacritty is the default terminal in the config
    #waybar
    #autotiling
    #wlsunset
    #cinnamon.nemo
    #jq
    #playerctl
    #wev
    #sirula
    #lxappearance
    #adapta-gtk-theme
    #gnome.adwaita-icon-theme
    #wdisplays
  #];
}
