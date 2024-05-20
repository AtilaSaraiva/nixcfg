{ pkgs, lib, ... }:

let
  lock = "${pkgs.swaylock}/bin/swaylock --clock --indicator --fade-in 0.2 --screenshots --effect-vignette 0.5:0.5 --effect-blur 7x5";
  oguriWallpaper = pkgs.writeShellScriptBin ''
    ${pkgs.killall}/bin/killall oguri
    kill $(pgrep mpvpaper)
    mkdir -p $HOME/.config/oguri
    touch $HOME/.config/oguri/config
    if [[ $1 == "animated" ]];
    then
        rm ~/.config/oguri/config
        for output in $(swaymsg -t get_outputs | jq -r '.[] | {name} | .name')
        do
            echo [output $output] >> ~/.config/oguri/config
            echo image=$(find ~/Files/Imagens/AnimatedWallpapers/ -type f | shuf -n 1) >> ~/.config/oguri/config
            echo filter=good >> ~/.config/oguri/config
            echo scaling-mode=fill >> ~/.config/oguri/config
            echo anchor=center >> ~/.config/oguri/config
            echo >> ~/.config/oguri/config
        done
    elif [[ $1 == "static" ]];
    then
        rm ~/.config/oguri/config
        for output in $(swaymsg -t get_outputs | jq -r '.[] | {name} | .name')
        do
            echo [output $output] >> ~/.config/oguri/config
            echo image=$(find ~/Files/Imagens/Favoritos/ -type f | shuf -n 1) >> ~/.config/oguri/config
            echo filter=good >> ~/.config/oguri/config
            echo scaling-mode=fill >> ~/.config/oguri/config
            echo anchor=center >> ~/.config/oguri/config
            echo >> ~/.config/oguri/config
        done
    else
        break
    fi

    ${pkgs.oguri}/bin/oguri
  '';
in
{
  #options.outputs = lib.mkOption {
    #type = lib.types.listOf lib.types.str;
    #defaul
  #};
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      defaultWorkspace = "workspace number 1";

      startup = [
        { command = "${lock}"; }
        { command = "${pkgs.mako}/bin/mako"; }
        { command = "${pkgs.qbittorrent}/bin/qbittorrent"; }
        { command = "${pkgs.udiskie}/bin/udiskie --tray"; }
        { command = "${pkgs.blueman}/bin/blueman-tray"; }
        { command = "${pkgs.wlsunset}/bin/wlsunset -l 53.631611 -L -113.323975"; }
        { command = "${pkgs.transmission-qt}/bin/transmission-qt"; }
        { command = "${pkgs.dropbox}/bin/dropbox"; }
        { command = "${pkgs.megasync}/bin/megasync"; }
        {
          command = ''${pkgs.swayidle}/bin/swayidle -w \
            timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
            before-sleep 'swaylock --clock --indicator --fade-in 0.2 --screenshots --effect-vignette 0.5:0.5 --effect-blur 7x5' \'';
        }
        { command = "${oguriWallpaper} static"; }
      ];

      output = {
        "*" = {
          max_render_time = "1";
          # In 60Hz display, "adaptive_sync" makes electron apps laggy
          adaptive_sync = "off";
        };
        "PanaScope Pixio PX277P Unknown" = {
          adaptive_sync = "on";
          mode = "2560x1440@164.999Hz";
        };
        "XXX PRO Unknown" = {
          mode = "3840x2160@60.000Hz";
        };
      };

    };
  };

  wayland.windowManager.sway.systemd.enable = true;

  #xdg.configFile."sway/config".source = ./config;

  #home.packages = with pkgs; [
    #aftergameopen
    #animatedWallpaper
    #bookmarkadd
    #energyPlan
    #i3empty
    #kill4game
    #oguriWallpaper
    #pmenu_g
    #portSwitch
    #remote
    #sway-display-swap
    #toggleFreesync
    #bigsteam
  #];

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
