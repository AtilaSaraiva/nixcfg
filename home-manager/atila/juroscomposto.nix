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
    outputs.homeManagerModules.bukusync

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
    ./features/sirula
    ./features/xournalpp
    ./features/tmux
    ./features/vifm
    ./features/sway
    ./features/lf
    ./features/zsh
    ./features/feh.nix
    ./features/wolframEngine.nix
    ./features/devtools.nix
    ./features/clitools.nix
    ./features/nixtools.nix
    ./features/flatpak.nix
    ./features/apps.nix
    ./features/defaults.nix
  ];

  displays = [
    {
      name = "DP-2";
      position = "0,0";
      mode = "2560x1440@164.999Hz";
    }
    {
      name = "HDMI-A-1";
      disable = "";
      position = "2560,0";
      mode = "3840x2160@60.000Hz";
    }
    {
      name = "HEADLESS-1";
      position = "6400,0";
      mode = "1280x800@60.000Hz";
      subpixel = "rgb";
    }
  ];

  keyboard = {
    xkb_layout = "br,us";
    xkb_variant = ",dvp";
  };

  services.bukusync.enable = true;

  zshmarks = ''
    $HOME/Files/storage/downloads|dw
    $HOME/Files/storage/|st
  '';

  services.flatpak.packages = [
    "com.heroicgameslauncher.hgl"
    "com.usebottles.bottles"
  ];

  home.packages = [
    (lib.hiPrio pkgs.mathematica)
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "21.05";
}
