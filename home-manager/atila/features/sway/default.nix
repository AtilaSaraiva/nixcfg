{ pkgs, lib, config, ... }:

let
  coreutilsBin = exe: "${pkgs.uutils-coreutils}/bin/uutils-${exe}";
  date = coreutilsBin "date";
  tr = coreutilsBin "tr";
  wc = coreutilsBin "wc";
  who = coreutilsBin "who";
  env = coreutilsBin "env";
  tty = coreutilsBin "tty";
  tmux = "${pkgs.tmux}/bin/tmux";

  mod = "Mod1";
  map-to-active = "swaymsg input type:tablet_tool map_to_output `swaymsg -t get_outputs | jq -r '.[] | select(.focused == true) | .name'`";
  mon0 = (builtins.elemAt config.displays 0).name;
  mon1 = (builtins.elemAt config.displays 1).name;
  # The last display in the list will be considered the TV, since this only affect the bigsteam script it should not be a big deal
  TV = (lib.last config.displays).name;
  innerGap = "20";
  outerGap = "6";
  browser = "${pkgs.qutebrowser}/bin/qutebrowser";
  menu = "${pkgs.sirula}/bin/sirula";
  term = "${pkgs.kitty}/bin/kitty";
  lock = "${pkgs.swaylock-effects}/bin/swaylock --clock --indicator --fade-in 0.2 --screenshots --effect-vignette 0.5:0.5 --effect-blur 7x5";

  todoRepo = "git@github.com:AtilaSaraiva/todo.git";
  todo = pkgs.writeShellScriptBin "todo" ''
    #!/usr/bin/env bash

    TODOPATH="/home/atila/Files/synced/phd/projects/todo"
    REPO="git@github.com:AtilaSaraiva/todo.git"
    GIT=${pkgs.git}/bin/git

    if [[ -d $TODOPATH ]]; then
        cd $TODOPATH
        $GIT pull || $GIT rebase --interactive
    else
        $GIT clone $REPO $TODOPATH || exit 1
    fi

    cd $TODOPATH

    # Open the file and commit changes
    ${pkgs.neovim}/bin/nvim todo.md
    $GIT add todo.md
    $GIT commit -m "WIP"

    # Push changes if online
    $GIT push origin main || exit 1
  '';

  snapWindowPinP = pkgs.writeShellScriptBin "snapWindowPinP" ''
    JQ=${pkgs.jq}/bin/jq

    if [ -z "$1" ]; then
        echo "Usage: $0 <direction>"
        echo "Directions: up, down, left, right"
        exit 1
    fi

    DIRECTION="$1"

    # Get screen width and height
    SCREEN_WIDTH=$(swaymsg -t get_outputs | $JQ '.[] | select(.focused) | .current_mode.width')
    SCREEN_HEIGHT=$(swaymsg -t get_outputs | $JQ '.[] | select(.focused) | .current_mode.height')

    # Get window info for the specified window
    WINDOW_INFO=$(swaymsg -t get_tree | $JQ '.. | select(.app_id? == "firefox" and .name? == "Picture-in-Picture") | .rect')
    WINDOW_X=$(echo "$WINDOW_INFO" | $JQ '.x')
    WINDOW_Y=$(echo "$WINDOW_INFO" | $JQ '.y')
    WINDOW_WIDTH=$(echo "$WINDOW_INFO" | $JQ '.width')
    WINDOW_HEIGHT=$(echo "$WINDOW_INFO" | $JQ '.height')

    # Check if window info was found
    if [ -z "$WINDOW_X" ] || [ -z "$WINDOW_Y" ] || [ -z "$WINDOW_WIDTH" ] || [ -z "$WINDOW_HEIGHT" ]; then
        echo "Window with app_id 'firefox' and title 'Picture-in-Picture' not found."
        exit 1
    fi

    # Calculate the center of the window
    WINDOW_CENTER_X=$((WINDOW_X + WINDOW_WIDTH / 2))
    WINDOW_CENTER_Y=$((WINDOW_Y + WINDOW_HEIGHT / 2))

    # Calculate distances to corners
    DIST_TL=$((WINDOW_CENTER_X * WINDOW_CENTER_X + WINDOW_CENTER_Y * WINDOW_CENTER_Y))
    DIST_TR=$(((SCREEN_WIDTH - WINDOW_CENTER_X) * (SCREEN_WIDTH - WINDOW_CENTER_X) + WINDOW_CENTER_Y * WINDOW_CENTER_Y))
    DIST_BL=$((WINDOW_CENTER_X * WINDOW_CENTER_X + (SCREEN_HEIGHT - WINDOW_CENTER_Y) * (SCREEN_HEIGHT - WINDOW_CENTER_Y)))
    DIST_BR=$(((SCREEN_WIDTH - WINDOW_CENTER_X) * (SCREEN_WIDTH - WINDOW_CENTER_X) + (SCREEN_HEIGHT - WINDOW_CENTER_Y) * (SCREEN_HEIGHT - WINDOW_CENTER_Y)))

    # Determine the closest corner
    CLOSEST_CORNER="tl"
    MIN_DIST=$DIST_TL

    if [ $DIST_TR -lt $MIN_DIST ]; then
        CLOSEST_CORNER="tr"
        MIN_DIST=$DIST_TR
    fi
    if [ $DIST_BL -lt $MIN_DIST ]; then
        CLOSEST_CORNER="bl"
        MIN_DIST=$DIST_BL
    fi
    if [ $DIST_BR -lt $MIN_DIST ]; then
        CLOSEST_CORNER="br"
        MIN_DIST=$DIST_BR
    fi

    # Calculate new position based on the given direction and closest corner
    case $CLOSEST_CORNER in
        tl)
            case $DIRECTION in
                up|left)
                    NEW_POS_X=0
                    NEW_POS_Y=0
                    ;;
                right)
                    NEW_POS_X=$((SCREEN_WIDTH - WINDOW_WIDTH))
                    NEW_POS_Y=0
                    ;;
                down)
                    NEW_POS_X=0
                    NEW_POS_Y=$((SCREEN_HEIGHT - WINDOW_HEIGHT))
                    ;;
            esac
            ;;
        tr)
            case $DIRECTION in
                up|right)
                    NEW_POS_X=$((SCREEN_WIDTH - WINDOW_WIDTH))
                    NEW_POS_Y=0
                    ;;
                left)
                    NEW_POS_X=0
                    NEW_POS_Y=0
                    ;;
                down)
                    NEW_POS_X=$((SCREEN_WIDTH - WINDOW_WIDTH))
                    NEW_POS_Y=$((SCREEN_HEIGHT - WINDOW_HEIGHT))
                    ;;
            esac
            ;;
        bl)
            case $DIRECTION in
                down|left)
                    NEW_POS_X=0
                    NEW_POS_Y=$((SCREEN_HEIGHT - WINDOW_HEIGHT))
                    ;;
                up)
                    NEW_POS_X=0
                    NEW_POS_Y=0
                    ;;
                right)
                    NEW_POS_X=$((SCREEN_WIDTH - WINDOW_WIDTH))
                    NEW_POS_Y=$((SCREEN_HEIGHT - WINDOW_HEIGHT))
                    ;;
            esac
            ;;
        br)
            case $DIRECTION in
                down|right)
                    NEW_POS_X=$((SCREEN_WIDTH - WINDOW_WIDTH))
                    NEW_POS_Y=$((SCREEN_HEIGHT - WINDOW_HEIGHT))
                    ;;
                up)
                    NEW_POS_X=$((SCREEN_WIDTH - WINDOW_WIDTH))
                    NEW_POS_Y=0
                    ;;
                left)
                    NEW_POS_X=0
                    NEW_POS_Y=$((SCREEN_HEIGHT - WINDOW_HEIGHT))
                    ;;
            esac
            ;;
    esac

    # Move the specified window
    swaymsg "[app_id=\"firefox\" title=\"Picture-in-Picture\"] move absolute position $NEW_POS_X $NEW_POS_Y"
  '';

  cornerWindowPinP = pkgs.writeShellScriptBin "cornerWindowPinP" ''
    JQ=${pkgs.jq}/bin/jq

    if [ -z "$1" ]; then
        echo "Usage: $0 <corner>"
        echo "Corners: br (bottom right), bl (bottom left), tr (top right), tl (top left)"
        exit 1
    fi

    CORNER="$1"

    # Get screen width and height
    SCREEN_WIDTH=$(swaymsg -t get_outputs | $JQ '.[] | select(.focused) | .current_mode.width')
    SCREEN_HEIGHT=$(swaymsg -t get_outputs | $JQ '.[] | select(.focused) | .current_mode.height')

    # Get window dimensions for the specified window
    WINDOW_INFO=$(swaymsg -t get_tree | $JQ '.. | select(.app_id? == "firefox" and .name? == "Picture-in-Picture") | .rect')
    WINDOW_WIDTH=$(echo "$WINDOW_INFO" | $JQ '.width')
    WINDOW_HEIGHT=$(echo "$WINDOW_INFO" | $JQ '.height')

    # Check if window dimensions were found
    if [ -z "$WINDOW_WIDTH" ] || [ -z "$WINDOW_HEIGHT" ]; then
        echo "Window with app_id 'firefox' and title 'Picture-in-Picture' not found."
        exit 1
    fi

    # Calculate positions
    case $CORNER in
        br)
            POS_X=$((SCREEN_WIDTH - WINDOW_WIDTH))
            POS_Y=$((SCREEN_HEIGHT - WINDOW_HEIGHT))
            ;;
        bl)
            POS_X=0
            POS_Y=$((SCREEN_HEIGHT - WINDOW_HEIGHT))
            ;;
        tr)
            POS_X=$((SCREEN_WIDTH - WINDOW_WIDTH))
            POS_Y=0
            ;;
        tl)
            POS_X=0
            POS_Y=0
            ;;
        *)
            echo "Invalid corner specified. Use: br, bl, tr, tl."
            exit 1
            ;;
    esac

    # Move the specified window
    swaymsg "[app_id=\"firefox\" title=\"Picture-in-Picture\"] move absolute position $POS_X $POS_Y"
  '';

  kill4game = pkgs.writeShellScriptBin "kill4game" ''
    kill $(${pkgs.procps}/bin/pgrep telegram) &
    kill $(${pkgs.procps}/bin/pgrep qutebrowser) &
    kill $(${pkgs.procps}/bin/pgrep firefox) &
    kill $(${pkgs.procps}/bin/pgrep qbittorrent) &
    kill $(${pkgs.procps}/bin/pgrep electron | head -n 1) &
    kill $(${pkgs.procps}/bin/pgrep chrome) &
    kill $(${pkgs.procps}/bin/pgrep dropbox) &
    kill $(${pkgs.procps}/bin/pgrep megasync) &
  '';

  bigsteam = pkgs.writeShellScriptBin "bigsteam" ''
    if [ -z "$1" ]; then
      echo "Usage: $0 <output_name>"
      exit 1
    fi

    TV_OUTPUT="$1"

    # Get all connected outputs
    OUTPUTS=$(swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.active == true) | .name')

    # Disable all outputs
    for OUTPUT in $OUTPUTS; do
        swaymsg output "$OUTPUT" disable
    done

    # Enable the TV output
    swaymsg output "$TV_OUTPUT" enable

    ## Optional: You may want to set the resolution and position for the TV output
    swaymsg output "$TV_OUTPUT" mode 3840x2160@60Hz pos 0 0

    swaymsg exec ${kill4game}/bin/kill4game

    # Start Steam in Big Picture mode
    swaymsg exec "steam -steamos3 -tenfoot"
  '';

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

    keyboard = {
      xkb_layout = lib.mkOption {
        type = lib.types.str;
        default = "br,us";
      };
      xkb_variant = lib.mkOption {
        type = lib.types.str;
        default = ",dvp";
      };
      xkb_options = lib.mkOption {
        type = lib.types.str;
        default = "caps:swapescape,grp:rwin_toggle";
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
              before-sleep '${lock}'
            '';
          }
          { command = "${oguriWallpaper}/bin/oguriWallpaper static"; }
          { command = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.clipman}/bin/clipman store --no-persist"; }
        ];

        output = {
          "*" = {
            max_render_time = "2";
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

          commands = [
            { criteria = { title = "Picture-in-Picture"; }; command = "floating enable; sticky enable; exec \"${cornerWindowPinP}/bin/cornerWindowPinP br\""; }
            { criteria = { title = "Firefox — Sharing Indicator"; }; command = "floating enable; sticky enable"; }
            { criteria = { app_id = ""; title = ".+\\(\\/run\\/current-system\\/sw\\/bin\\/gpg .+"; }; command = "floating enable; sticky enable"; }
            { criteria = { app_id = "org.telegram.desktop"; }; command = "floating enable, resize set 1600 900, move scratchpad"; }
            { criteria = { title = "Slack \\| mini panel"; }; command = "floating enable; stick enable"; }
            { criteria = { title = "discord.com is sharing your screen."; }; command = "move scratchpad"; }
            # Don't lock my screen if there is anything fullscreen, I may be gaiming
            { criteria = { shell = ".*"; }; command = "inhibit_idle fullscreen"; }
            { criteria = { app_id = "org.qbittorrent.qBittorrent"; }; command = "move scratchpad"; }
            { criteria = { instance = "spotify"; }; command = "move scratchpad, resize set 1600 900, move position 160px 100px"; }
            { criteria = { class = "Element"; }; command = "move scratchpad"; }
            { criteria = { class = "steam"; }; command = "floating enable"; }
            { criteria = { class = "Slack"; }; command = "move scratchpad"; }
            { criteria = { app_id = "com.rafaelmardojai.Blanket"; }; command = "move scratchpad"; }
            { criteria = { app_id = "dropdown_terminal"; }; command = "floating enable, sticky enable, resize set 1800 400, move position center, move down 300 px"; }
            { criteria = { app_id = "transmission-qt"; title="Transmission"; }; command = "move scratchpad"; }
            { criteria = { class = "Bitwarden"; }; command = "move scratchpad"; }
            { criteria = { app_id = "todolist"; }; command = "floating enable, sticky enable"; }
            { criteria = { app_id = "klavaro"; }; command = "floating enable"; }
          ];
        };

        keybindings = lib.mkOptionDefault {
          "${mod}+Ctrl+c" = "exec ${term} --class todolist ${todo}/bin/todo";
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
          "${mod}+Shift+backslash" = "output ${mon0} toggle";
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
          "${mod}+Shift+semicolon" = "exec qutebrowser http://127.0.0.1:3875";
          "${mod}+semicolon" = "exec ${pkgs.mako}/bin/makoctl dismiss --all";
          "${mod}+Shift+i" = "exec ${term} --class bookmarkViewer -e oil";
          "${mod}+Pause" = "exec systemctl suspend";
          "${mod}+Ctrl+o" = "exec \"${pkgs.rofi}/bin/rofi -show run -font 'DejaVu 9' -run-shell-command '{terminal} -e \" {cmd}; read -n 1 -s\"'\"";
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
          "--release Ctrl+Shift+Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
          "${mod}+Shift+f" = "gaps inner current toggle ${innerGap}; gaps outer current toggle ${outerGap}";
          "${mod}+Shift+z" = "exec ${lock}";
          "--release ${mod}+i" = "exec ${oguriWallpaper}/bin/oguriWallpaper static";
          "${mod}+Shift+d" = "exec ${term} -t 'launcher' -e ${pkgs.sway-launcher-desktop}/bin/sway-launcher-desktop";
          "${mod}+q" = "mode \"apps\"";
          "${mod}+Shift+p" = "mode \"PinPmove\"";
          "${mod}+r" = "mode \"resize\"";
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
          "type:keyboard" = {
            xkb_layout  = config.keyboard.xkb_layout;
            xkb_variant = config.keyboard.xkb_variant;
            xkb_options = config.keyboard.xkb_options;
          };
          "type:mouse" = {
            accel_profile = "flat"; # disable mouse acceleration
            pointer_accel = "-0.1"; # set mouse sensitivity
          };
          "1386:890:Wacom_One_by_Wacom_S_Pen" = {
            # left_handed = "enabled";
          };
          "2:10:TPPS/2_IBM_TrackPoint" = {
            pointer_accel = "-0.3"; # set mouse sensitivity
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

        modes =
        let
          withLeaveOptions = attrs: attrs // {
            "Return" = "mode default";
            "Escape" = "mode default";
          };
        in
        lib.mkOptionDefault {
          "apps" = withLeaveOptions {
            "m" = "exec ${pkgs.spotify}/bin/spotify; [instance=\"spotify\"] scratchpad show; mode default";
            "c" = "exec ${pkgs.bitwarden}/bin/bitwarden; mode default";
            "z" = "exec ${pkgs.firefox}/bin/firefox \"https://web.whatsapp.com/\"; mode default";
            "s" = "exec steam -steamos3; mode default";
            "period" = "exec ${bigsteam}/bin/bigsteam ${TV}";
            "d" = "exec env -u WAYLAND_DISPLAY lutris; mode default";
            "y" = "exec \"QT_QPA_PLATFORM=xcb yuzu\"; mode default";
            "e" = "exec element-desktop; mode default";
            "b" = "exec ${pkgs.blanket}/bin/blanket; mode default";
            "f" = "exec ${pkgs.firefox}/bin/firefox; mode default";
            "g" = "exec ${pkgs.firefox}/bin/firefox -private-window; mode default";
            "j" = "exec ${pkgs.inkscape}/bin/inkscape; mode default";
            "p" = "exec ${pkgs.pavucontrol}/bin/pavucontrol; mode default";
            "h" = "exec ${term} -e htop; mode default";
          };
          "PinPmove" = withLeaveOptions {
            "j" = "exec ${snapWindowPinP}/bin/snapWindowPinP down";
            "k" = "exec ${snapWindowPinP}/bin/snapWindowPinP up";
            "l" = "exec ${snapWindowPinP}/bin/snapWindowPinP right";
            "h" = "exec ${snapWindowPinP}/bin/snapWindowPinP left";
          };
        };
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

    programs.zsh.profileExtra = ''
      if [ -z "$tmux" ] &&  [ "$ssh_client" != "" ]; then
        exec ${tmux}
    '' + ''
      elif [ "$(${tty})" = '/dev/tty1' ]; then
        # It has to be sway from home manager.
        ${config.wayland.windowManager.sway.package}/bin/sway
    '' + ''
      fi
    '';
  };
}
