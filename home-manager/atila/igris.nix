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
    ./features/nvim
    ./features/julia
    ./features/jupyter
    ./features/ssh
    ./features/git
    ./features/waybar
    ./features/kitty
    ./features/mpv
    ./features/zathura
    ./features/qutebrowser
    ./features/tmux
    ./features/sway
    ./features/lf
    ./features/zsh
    ./features/feh.nix
    ./features/devtools.nix
    ./features/clitools.nix
    ./features/nixtools.nix
    ./features/apps.nix
    ./features/defaults.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "21.11";

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
  ];

  keyboard = {
    xkb_layout = "us,us";
    xkb_variant = "altgr-intl,dvp";
  };
}
