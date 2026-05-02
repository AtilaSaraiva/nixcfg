# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ../common/features/nvim
    ../common/features/julia
    ../common/features/jupyter
    ../common/features/ssh
    ../common/features/git
    ../common/features/waybar
    ../common/features/kitty
    ../common/features/mpv
    ../common/features/zathura
    ../common/features/qutebrowser
    ../common/features/tmux
    ../common/features/vifm
    ../common/features/yazi
    ../common/features/sirula
    ../common/features/xournalpp
    ../common/features/inkscape
    ../common/features/sway
    ../common/features/lf
    ../common/features/zsh
    ../common/features/feh.nix
    ../common/features/wolframEngine.nix
    ../common/features/devtools.nix
    ../common/features/clitools.nix
    ../common/features/nixtools.nix
    ../common/features/nix.nix
    ../common/features/apps.nix
    ../common/features/flatpak.nix
    ../common/features/defaults.nix
  ];

  displays = [
    {
      name = "eDP-1";
      position = "0,0";
      mode = "1920x1080@60.010Hz";
    }
    {
      name = "HDMI-A-1";
      position = "1080,0";
      res = "1920x1080";
    }
    {
      name = "HEADLESS-1";
      mode = "3840x2160@60.000Hz";
      disable = "";
    }
  ];

  services.flatpak.packages = [
    "com.heroicgameslauncher.hgl"
  ];

  keyboard = {
    xkb_layout = "us,us";
    xkb_variant = "altgr-intl,dvp";
    xkb_options = "caps:swapescape,grp:ralt_rshift_toggle";
  };

  home.packages = [
    (lib.hiPrio pkgs.stable.mathematica)
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "21.11";

}
