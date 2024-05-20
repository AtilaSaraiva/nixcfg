{ pkgs, lib, config, ... }:

let
  mod = "Mod1";
  map-to-active = "swaymsg input type:tablet_tool map_to_output `swaymsg -t get_outputs | jq -r '.[] | select(.focused == true) | .name'`";
  mon0 = (builtins.elemAt config.displays 0).name;
  mon1 = (builtins.elemAt config.displays 1).name;
  innerGap = "20";
  outerGap = "6";
  browser = "${pkgs.qutebrowser}/bin/qutebrowser";
  menu = "${pkgs.sirula}/bin/sirula";
  term = "${pkgs.kitty}/bin/kitty";
  lock = "${pkgs.swaylock-effects}/bin/swaylock --clock --indicator --fade-in 0.2 --screenshots --effect-vignette 0.5:0.5 --effect-blur 7x5";

  oguriWallpaper = pkgs.writeShellScriptBin "oguriWallpaper" ''
    ${pkgs.killall}/bin/killall oguri
    kill $(pgrep mpvpaper)
    mkdir -p $HOME/.config/oguri
    touch $HOME/.config/oguri/config
    if [[ $1 == "animated" ]];
    then
        rm ~/.config/oguri/config
        for output in $(swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | {name} | .name')
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
        for output in $(swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | {name} | .name')
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


  bookmarkadd = pkgs.writeShellScriptBin "bookmarkadd" ''
    session=$(echo $XDG_SESSION_TYPE)
      if [[ $session == "x11" ]];then
          clipboard=$(xsel -b)
      else
          clipboard=$(${pkgs.wl-clipboard}/bin/wl-paste)
      fi
      tags=$(${pkgs.rofi}/bin/rofi -dmenu -p 'tags' -font "Fantasque Sans Mono 20")
      if test -n "$tags" && test -n "$clipboard"
      then
          ${pkgs.buku}/bin/buku -a $clipboard $tags
          ${pkgs.libnotify}/bin/notify-send "Bookmarked URL
          $clipboard"
      fi
  '';


  toggleFreesync = pkgs.writeShellScriptBin "toggleFreesync" ''
    # Check if the file /tmp/freesync exists
    if [ -f "/tmp/freesync" ]; then
        # Check if the file contains the number 0
        if grep -q "0" "/tmp/freesync"; then
            swaymsg "output * adaptive_sync on"
            # Change the value in the file to 1
            sed -i 's/0/1/g' "/tmp/freesync"
        else
            swaymsg "output * adaptive_sync off"
            sed -i 's/1/0/g' "/tmp/freesync"
        fi
    else
        swaymsg "output * adaptive_sync on"
        echo "1" > "/tmp/freesync"
    fi
  '';

  i3empty = "${pkgs.i3empty}/bin/i3empty";

  pmenu_g = pkgs.writeShellScriptBin "pmenu_g" ''
    MENU="$(${pkgs.rofi}/bin/rofi -sep "|" -dmenu -i -p 'System' -location 5 -yoffset -75 -xoffset -69 -width 20 -hide-scrollbar -line-padding 4 -padding 20 -lines 8 -font "Fantasque Sans Mono 20" <<< "⏽ Lock|⏼ Reboot|⏻ Shutdown|Hibernate|Suspend|Hybrid")"
              case "$MENU" in
                  *Lock) ${lock} ;;
                  *Reboot) systemctl reboot ;;
                  *Shutdown) systemctl -i poweroff ;;
                  *Hibernate) systemctl hibernate ;;
                  *Suspend) systemctl suspend ;;
                  *Hybrid) systemctl hybrid-sleep
              esac
  '';
in
{
  options = {
    displays = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = { };
    };

    keyboard = lib.mkOption {
      type = lib.types.attrs;
      default = {
        xkb_layout = "br,us";
        xkb_variant = ",dvp";
        xkb_options = "caps:swapescape,grp:rwin_toggle";
      };
    };
  };

  imports = [
    ../i3status-rust.nix
  ];

  config = {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = {
        defaultWorkspace = "workspace number 1";

        fonts = {
          names = [ "pango:RobotoMono" ];
          size  = 8.0;
        };
        startup = [
          { command = "${lock}"; }
          { command = "${pkgs.mako}/bin/mako"; }
          { command = "${pkgs.autotiling}/bin/autotiling"; }
          { command = "${pkgs.qbittorrent}/bin/qbittorrent"; }
          { command = "${pkgs.udiskie}/bin/udiskie --tray"; }
          { command = "${pkgs.blueman}/bin/blueman-tray"; }
          { command = "${pkgs.wlsunset}/bin/wlsunset -l 53.631611 -L -113.323975"; }
          { command = "${pkgs.transmission-qt}/bin/transmission-qt"; }
          { command = "${pkgs.dropbox}/bin/dropbox"; }
          { command = "flatpak run nz.mega.MEGAsync"; }
          {
            command = ''${pkgs.swayidle}/bin/swayidle -w \
              timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
              before-sleep 'swaylock --clock --indicator --fade-in 0.2 --screenshots --effect-vignette 0.5:0.5 --effect-blur 7x5'';
          }
          { command = "${oguriWallpaper}/bin/oguriWallpaper static"; }
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
        } // builtins.listToAttrs (map (display: {
          name = display.name;
          value = builtins.removeAttrs display [ "name" ];
        }) config.displays);

        workspaceOutputAssign = [
          { output = mon0; workspace = "1"; }
          { output = mon1; workspace = "10"; }
        ];

        focus = {
          followMouse = false;
        };

        floating.border = 3;
        floating.modifier = "${mod}";

        window = {
          border = 3;
          titlebar = false;
          #hideEdgeBorders = "both";

          commands = [
            { criteria = { app_id = "firefox"; title = "Picture-in-Picture"; }; command = "floating enable; sticky enable"; }
            { criteria = { app_id = "firefox"; title = "Firefox — Sharing Indicator"; }; command = "floating enable; sticky enable"; }
            { criteria = { app_id = ""; title = ".+\\(\\/run\\/current-system\\/sw\\/bin\\/gpg .+"; }; command = "floating enable; sticky enable"; }
            { criteria = { app_id = "org.telegram.desktop"; title = "TelegramDesktop"; }; command = "move scratchpad"; }
            { criteria = { title = "Slack \\| mini panel"; }; command = "floating enable; stick enable"; }
            { criteria = { title = "discord.com is sharing your screen."; }; command = "move scratchpad"; }
            # Don't lock my screen if there is anything fullscreen, I may be gaiming
            { criteria = { shell = ".*"; }; command = "inhibit_idle fullscreen"; }
            { criteria = { app_id = "org.qbittorrent.qBittorrent"; }; command = "move scratchpad"; }
            { criteria = { instance = "spotify"; }; command = "move scratchpad, resize set 1600 900, move position 160px 100px"; }
            { criteria = { class = "Element"; }; command = "move scratchpad"; }
            { criteria = { class = "steam"; }; command = "floating enable"; }
            { criteria = { class = "Slack"; }; command = "move scratchpad"; }
            { criteria = { instance = "origin.exe"; }; command = "floating enable"; }
            { criteria = { class = "origin.exe"; }; command = "floating enable"; }
            { criteria = { app_id = "com.rafaelmardojai.Blanket"; }; command = "move scratchpad"; }
            { criteria = { app_id = "dropdown_terminal"; }; command = "floating enable, sticky enable, resize set 1800 400, move position center, move down 300 px"; }
            { criteria = { class = "transmission-qt"; }; command = "move scratchpad"; }
            { criteria = { class = "Bitwarden"; }; command = "move scratchpad"; }
          ];
        };

        keybindings = lib.mkOptionDefault {
          "${mod}+ccedilla" = "exec ${toggleFreesync}/bin/toggleFreesync";
          "${mod}+Shift+o" = "exec ${bookmarkadd}/bin/bookmarkadd";
          "${mod}+Delete" = "exec kill4game";
          "${mod}+Insert" = "exec aftergameopen";
          "${mod}+Return" = "exec ${term}";
          "${mod}+t" = "exec ${term} --class dropdown_terminal -e zsh";
          "${mod}+n" = "exec ${term} --class lf -e ${pkgs.lf}/bin/lf";
          "${mod}+Shift+n" = "exec ${term} --class=notes vifm ~/Files/Mega/phd/notes";
          "${mod}+Shift+q" = "kill";
          "${mod}+b" = "exec ${browser}";
          "${mod}+d" = "exec ${menu}";
          "${mod}+backslash" = "output ${mon1} toggle";
          "${mod}+u" = "focus output left";
          "${mod}+Shift+minus" = "move scratchpad";
          "${mod}+minus" = "scratchpad show";
          "${mod}+Ctrl+t" = "[app_id=\"org.telegram.desktop\"] scratchpad show";
          "${mod}+Ctrl+b" = "[app_id=\"com.rafaelmardojai.Blanket\"] scratchpad show";
          "${mod}+Ctrl+a" = "[class=\"Bitwarden\"] scratchpad show";
          "${mod}+Ctrl+d" = "[app_id=\"org.qbittorrent.qBittorrent\"] scratchpad show";
          "${mod}+Ctrl+q" = "[instance=\"spotify\"] scratchpad show";
          "${mod}+Ctrl+r" = "[class=\"Slack\"] scratchpad show";
          "${mod}+Ctrl+e" = "[class=\"Element\"] scratchpad show";
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";
          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";
          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";
          "${mod}+s" = "split toggle";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+w" = "layout tabbed";
          "${mod}+e" = "layout toggle split";
          "${mod}+Shift+space" = "floating toggle, sticky disable";
          "${mod}+Ctrl+f" = "focus floating, fullscreen enable";
          "${mod}+Ctrl+c" = "fullscreen disable, focus tiling";
          "${mod}+space" = "focus mode_toggle";
          "${mod}+Shift+s" = "sticky toggle";
          "${mod}+1" = "workspace 1, focus tiling; exec ${map-to-active}";
          "${mod}+2" = "workspace 2, focus tiling; exec ${map-to-active}";
          "${mod}+3" = "workspace 3, focus tiling; exec ${map-to-active}";
          "${mod}+4" = "workspace 4, focus tiling; exec ${map-to-active}";
          "${mod}+5" = "workspace 5, focus tiling; exec ${map-to-active}";
          "${mod}+6" = "workspace 6, focus tiling; exec ${map-to-active}";
          "${mod}+7" = "workspace 7, focus tiling; exec ${map-to-active}";
          "${mod}+8" = "workspace 8, focus tiling; exec ${map-to-active}";
          "${mod}+9" = "workspace 9, focus tiling; exec ${map-to-active}";
          "${mod}+v" = "workspace 8, workspace 9, focus tiling; exec ${map-to-active}";
          "${mod}+0" = "workspace 10, focus tiling; exec ${map-to-active}";
          "${mod}+bracketright" = "workspace next_on_output";
          "${mod}+bracketleft" = "workspace prev_on_output";
          "${mod}+Shift+1" = "move container to workspace 1";
          "${mod}+Shift+2" = "move container to workspace 2";
          "${mod}+Shift+3" = "move container to workspace 3";
          "${mod}+Shift+4" = "move container to workspace 4";
          "${mod}+Shift+5" = "move container to workspace 5";
          "${mod}+Shift+6" = "move container to workspace 6";
          "${mod}+Shift+7" = "move container to workspace 7";
          "${mod}+Shift+8" = "move container to workspace 8";
          "${mod}+Shift+9" = "move container to workspace 9";
          "${mod}+Shift+v" = "move container to workspace 9";
          "${mod}+Shift+0" = "move container to workspace 10";
          "${mod}+Ctrl+h" = "exec --no-startup-id ${i3empty} prev";
          "${mod}+Ctrl+l" = "exec --no-startup-id ${i3empty} next";
          "${mod}+Shift+Ctrl+h" = "exec --no-startup-id ${i3empty} --move prev";
          "${mod}+Shift+Ctrl+l" = "exec --no-startup-id ${i3empty} --move next";
          "${mod}+x" = "move workspace to output right";
          "${mod}+Shift+x" = "move container to output right";
          "${mod}+c" = "exec ${pkgs.sway-display-swap}/bin/sway-display-swap";
          #"${mod}+m" = "exec i3-input -F 'mark %s' -l 1 -P 'Mark: '";
          #"${mod}+g" = "exec i3-input -F '[con_mark=\"%s\"] focus' -l 1 -P 'Goto: '";
          "${mod}+Shift+semicolon" = "exec qutebrowser http://127.0.0.1:3875";
          "${mod}+semicolon" = "exec makoctl dismiss --all";
          "${mod}+Shift+i" = "exec ${term} --class bookmarkViewer -e oil";
          #"${mod}+Shift+y" = "exec ejectUSB";
          #"${mod}+z" = "exec energyPlanMenu";
          "${mod}+Pause" = "exec systemctl suspend";
          "${mod}+Ctrl+o" = "exec \"rofi -show run -font 'DejaVu 9' -run-shell-command '{terminal} -e \" {cmd}; read -n 1 -s\"'\"";
          "${mod}+comma" = "exec amixer set Master -q 5%-";
          "${mod}+period" = "exec amixer set Master -q 5%+";
          "XF86AudioRaiseVolume" = "exec --no-startup-id amixer set Master -q 5%+";
          "XF86AudioLowerVolume" = "exec --no-startup-id amixer set Master -q 5%-";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 0 toggle";
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl pause";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
          "${mod}+dead_tilde" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "${mod}+Shift+comma" = "exec ${pkgs.playerctl}/bin/playerctl previous";
          "${mod}+Shift+period" = "exec ${pkgs.playerctl}/bin/playerctl next";
          "--locked XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s +5%";
          "--locked XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s 5%-";
          "${mod}+p" = "exec portSwitch";
          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+r" = "restart";
          "${mod}+Shift+e" = "exec ${pmenu_g}/bin/pmenu_g";
          "--release Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy output";
          "--release Shift+Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy window";
          #"--release Ctrl+Shift+Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
          "${mod}+Shift+f" = "gaps inner current toggle ${innerGap}; gaps outer current toggle ${outerGap}";
          "${mod}+Shift+z" = "exec ${lock}";
          "--release ${mod}+i" = "exec ${oguriWallpaper}/bin/oguriWallpaper static";
          "${mod}+q" = "mode \"apps\"";
          "${mod}+r" = "mode \"resize\"";
          "${mod}+Shift+d" = "exec ${term} -t 'launcher' -e /usr/bin/sway-launcher-desktop";
        };

        bars = [{
          fonts = {
            names = [ "Font Awesome 5 Free" ];
            size = 9.0;
          };
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-main.toml";
          colors = {
            separator = "#666666";
            background = "#222222dd";
            statusline = "#dddddd";
            focusedWorkspace = { background = "#0088CC"; border = "#0088CC"; text = "#ffffff"; };
            activeWorkspace = { background = "#333333"; border = "#333333"; text = "#ffffff"; };
            inactiveWorkspace = { background = "#333333"; border = "#333333"; text = "#888888"; };
            urgentWorkspace = { background = "#2f343a"; border = "#900000"; text = "#ffffff"; };
          };
          #extraConfig = ''
            #output "${seat.displayId}"
          #'';
        }];

        colors = {
          focused = {
            background = "#bb47e5";
            border = "#bb47e5";
            childBorder = "#bb47e5";
            indicator = "#bb47e5";
            text = "#ffffff";
          };
          urgent = {
            background = "#900000";
            border = "#ffffff";
            childBorder = "#ffffff";
            indicator = "#c8395b";
            text = "#ffffff";
          };
        };

        input = {
          "type:keyboard" = config.keyboard // { xkb_options = "caps:swapescape"; };
          "type:mouse" = {
            accel_profile = "flat"; # disable mouse acceleration
            pointer_accel = "-0.1"; # set mouse sensitivity
          };
          "1386:890:Wacom_One_by_Wacom_S_Pen" = {
            # left_handed = "enabled";
          };
          "type:touchpad" = {
            tap = "enabled";
          };
        };

        seat = {
          "*" = {
            hide_cursor = "when-typing enable";
          };
        };

        workspaceAutoBackAndForth = true;
      };
      extraOptions = [ "-Dnoscanout" ];
      extraSessionCommands = ''
        export MOZ_ENABLE_WAYLAND=1
      '';
    };

    wayland.windowManager.sway.systemd.enable = true;

    home.packages = with pkgs; [
      xwayland
      swaytools
      wf-recorder
      wl-clipboard
      cinnamon.nemo
      wev
      lxappearance
      adapta-gtk-theme
      gnome.adwaita-icon-theme
      wdisplays
    ];
  };
}
