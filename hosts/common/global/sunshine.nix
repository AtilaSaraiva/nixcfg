{ pkgs, lib, ... }:

let
  # Fallbacks for the headless output, only used if sunshine somehow does not
  # hand us the client's own numbers (see SUNSHINE_CLIENT_* below).
  fallbackWidth = "3840";
  fallbackHeight = "2160";
  fallbackFps = "60";

  # The virtual output sway creates at startup (see the sway home-manager
  # config: `swaymsg create_output HEADLESS-1`).
  headlessOutput = "HEADLESS-1";

  # The sunshine user service runs with PATH cleared (the NixOS module forces it
  # to null so the tray menu works), so everything below has to be absolute.
  swaymsg = "${pkgs.sway-unwrapped}/bin/swaymsg";
  jq = "${pkgs.jq}/bin/jq";
  sleep = "${pkgs.coreutils}/bin/sleep";
  rm = "${pkgs.coreutils}/bin/rm";

  # Which physical outputs were on before the stream started, so `undo` can put
  # the desktop back the way it was.
  stateFile = "\${XDG_RUNTIME_DIR:-/tmp}/sunshine-saved-outputs";

  # Move the sway session onto the headless output at the client's resolution.
  # Every physical output is turned off so that HEADLESS-1 ends up being the
  # only wl_output sunshine can see -- that is how it picks what to capture.
  #
  # SUNSHINE_CLIENT_{WIDTH,HEIGHT,FPS} are exported by sunshine itself and hold
  # whatever the connecting moonlight client asked for, so the headless output
  # follows the client instead of being pinned to one resolution: 4K from the
  # TV, 1280x800 from the deck, without needing a separate app entry for each.
  streamStart = pkgs.writeShellScript "sunshine-stream-start" ''
    set -eu

    width="''${SUNSHINE_CLIENT_WIDTH:-${fallbackWidth}}"
    height="''${SUNSHINE_CLIENT_HEIGHT:-${fallbackHeight}}"
    fps="''${SUNSHINE_CLIENT_FPS:-${fallbackFps}}"

    if ! ${swaymsg} -t get_outputs \
        | ${jq} -e --arg o "${headlessOutput}" 'any(.[]; .name == $o)' >/dev/null; then
      ${swaymsg} create_output ${headlessOutput}
      # create_output is asynchronous, give sway a moment to advertise it.
      ${sleep} 1
    fi

    ${swaymsg} output ${headlessOutput} enable
    # A mode sway refuses would otherwise abort the prep-cmd and kill the whole
    # stream, so fall back rather than fail.
    ${swaymsg} output ${headlessOutput} mode "''${width}x''${height}@''${fps}Hz" \
      || ${swaymsg} output ${headlessOutput} mode "${fallbackWidth}x${fallbackHeight}@${fallbackFps}Hz"
    ${swaymsg} output ${headlessOutput} pos 0 0

    ${swaymsg} -t get_outputs \
      | ${jq} -r --arg o "${headlessOutput}" '.[] | select(.active and .name != $o) | .name' \
      > "${stateFile}"

    while read -r output; do
      ${swaymsg} output "$output" disable
    done < "${stateFile}"

    # Cosmetic, and not worth failing the whole stream over.
    ${swaymsg} focus output ${headlessOutput} || true
  '';

  # Put the physical outputs back and drop the headless one. Sway re-applies the
  # matching `output` config block when an output is re-enabled, so the modes
  # from home-manager come back on their own.
  streamStop = pkgs.writeShellScript "sunshine-stream-stop" ''
    set -eu

    if [ -s "${stateFile}" ]; then
      while read -r output; do
        ${swaymsg} output "$output" enable
      done < "${stateFile}"
      ${rm} -f "${stateFile}"
    fi

    ${swaymsg} output ${headlessOutput} disable
  '';

  # `steam://open/gamepadui` only does anything when Steam is already running;
  # a cold start needs the -gamepadui flag instead.
  steamBigPicture = pkgs.writeShellScript "sunshine-steam-bigpicture" ''
    set -eu

    steam=/run/current-system/sw/bin/steam

    if ${pkgs.procps}/bin/pgrep -x steam >/dev/null 2>&1; then
      exec "$steam" steam://open/gamepadui
    else
      exec "$steam" -gamepadui
    fi
  '';

  # Heroic is a per-user flatpak, so it has to go through `flatpak run`.
  # --console is heroic's own big-picture view (the /console route, gamepad
  # navigable); --fullscreen keeps it from opening as a floating window.
  heroicConsole = pkgs.writeShellScript "sunshine-heroic-console" ''
    set -eu

    exec /run/current-system/sw/bin/flatpak run \
      com.heroicgameslauncher.hgl --console --fullscreen
  '';
in
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    # Moonlight talks to 47989/47990 and friends; without this the only way in
    # is over tailscale0 (which network.nix already trusts).
    openFirewall = true;

    settings = {
      sunshine_name = "nixos";
      # Base port. Everything else is an offset from it, so leaving it at the
      # default is what lets Moonlight find the host without manual setup.
      # (The web UI lands on 47990 = port + 1.)
      port = 47989;
      capture = "wlr";

      # Applied around every app below that sets exclude-global-prep-cmd=false.
      global_prep_cmd = builtins.toJSON [
        {
          do = "${streamStart}";
          undo = "${streamStop}";
        }
      ];
    };

    applications = {
      env = {
        # The systemd user service runs with no PATH (the module clears it), and
        # the steam wrapper needs one.
        PATH = "/run/current-system/sw/bin:/run/wrappers/bin:$(PATH)";
      };
      apps = [
        {
          name = "Steam Big Picture";
          cmd = "${steamBigPicture}";
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "Heroic Games Launcher";
          cmd = "${heroicConsole}";
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "0ad";
          cmd = "/run/current-system/sw/bin/0ad";
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
      ];
    };
  };

  # Sunshine creates virtual gamepads/keyboard/mouse through /dev/uinput; without
  # these groups the stream connects but no input reaches the host.
  users.users.atila.extraGroups = [ "input" "uinput" ];

  # Moonlight's host auto-discovery is mDNS, and printing.nix closes avahi's
  # port. Open it so clients find the machine instead of needing a manual IP.
  services.avahi.openFirewall = lib.mkForce true;
}
