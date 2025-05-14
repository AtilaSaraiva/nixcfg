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
    ./features/zathura
    ./features/qutebrowser
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
    ./features/defaults.nix
  ];

  displays = [
    {
      name = "X11-1";
      position = "0,0";
      mode = "1280x800";
    }
    {
      name = "HDMI-A-1";
      disable = "";
      position = "1280,0";
      mode = "3840x2160@60.000Hz";
    }
  ];

  folders = {
    repos = "codes";
    projects = "projects";
    nixcfg = "codes/nixcfg";
  };

  home = {
    username = "deck";
    homeDirectory = "/home/deck";
  };

  nixGL.packages = inputs.nixgl.packages;
  nixGL.defaultWrapper = "mesa";

  wayland.windowManager.sway.package = (config.lib.nixGL.wrap pkgs.sway);

  home.packages = with pkgs; [
      borg-sans-mono
      cantarell-fonts
      fira
      fira-code
      fira-code-symbols
      font-awesome_4
      font-awesome_5
      noto-fonts
      noto-fonts-cjk-sans
      open-fonts
      ubuntu_font_family
      dejavu_fonts
      freefont_ttf
      gyre-fonts # TrueType substitutes for standard PostScript fonts
      liberation_ttf
      unifont
      noto-fonts-color-emoji
  ];

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Roboto" ];
        monospace = [ "Fira Code" ];
      };
    };
  };

  programs.zsh.oh-my-zsh.theme = "kolo";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
