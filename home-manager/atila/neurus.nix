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
    ../common/features/zathura
    ../common/features/qutebrowser
    ../common/features/tmux
    ../common/features/vifm
    ../common/features/yazi
    ../common/features/lf
    ../common/features/zsh
    ../common/features/feh.nix
    ../common/features/devtools.nix
    ../common/features/clitools.nix
    ../common/features/nixtools.nix
    ../common/features/nix.nix
    ../common/features/defaults.nix
  ];

  folders = {
    repos = "codes";
    projects = "projects";
    nixcfg = "codes/nixcfg";
  };

  home = {
    username = "saraivaq";
    homeDirectory = "/home/saraivaq";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
