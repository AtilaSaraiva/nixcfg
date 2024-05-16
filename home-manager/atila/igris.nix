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
    ./features/nvim/nvim.nix
    ./features/julia/julia.nix
    ./features/jupyter/jupyter.nix
    ./features/ssh/ssh.nix
    ./features/git/git.nix
    ./features/zsh.nix
    ./features/waybar/waybar.nix
    ./features/kitty/kitty.nix
    ./features/mpv/mpv.nix
    ./features/zathura/zathura.nix
    ./features/qutebrowser/qutebrowser.nix
    ./features/tmux/tmux.nix
    ./features/lf/lf.nix
    ./features/feh.nix
    ./features/sway/sway.nix
    ./features/defaults.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "21.05";
}
