{ pkgs, ... }:

{
  xdg.portal = {
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-kde
    ];
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
      sway = {
        default = [
          "wlr"
        ];
      };
    };
  };

  # I need this to configure sway from home-manager in the future
  security.polkit.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock-effects
      xwayland
      swayidle
      swaytools
      killall
      oguri
      wf-recorder
      wl-clipboard
      sway-contrib.grimshot
      mako # notification daemon
      kitty # Alacritty is the default terminal in the config
      waybar
      autotiling
      wlsunset
      cinnamon.nemo
      jq
      playerctl
      wev
      sirula
      lxappearance
      adapta-gtk-theme
      gnome.adwaita-icon-theme
      wdisplays
      rofi
    ];
    extraSessionCommands = ''
      #export SDL_VIDEODRIVER=wayland
      #export QT_QPA_PLATFORM=wayland
      #export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };
}
