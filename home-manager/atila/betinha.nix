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
    ./features/flatpak.nix
    ./features/defaults.nix
  ];

  displays = [
    {
      name = "DP-1";
      position = "0,0";
      mode = "1920x1080@60.000Hz";
    }
    {
      name = "DP-2";
      position = "1920,0";
      mode = "1920x1080@60.000Hz";
      transform = "270";
    }
  ];

  keyboard = {
    xkb_layout = "br,us";
    xkb_variant = ",dvp";
  };

  zshmarks = ''
    $HOME/Files/Codigos/repos|repos
    $HOME/Files/Codigos/repos/new-nixos-config|ni
  '';

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
