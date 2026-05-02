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
    ../common/features/xournalpp
    ../common/features/inkscape
    ../common/features/tmux
    ../common/features/vifm
    ../common/features/yazi
    ../common/features/sway
    ../common/features/lf
    ../common/features/zsh
    ../common/features/feh.nix
    ../common/features/wolframEngine.nix
    ../common/features/devtools.nix
    ../common/features/clitools.nix
    ../common/features/nixtools.nix
    ../common/features/nix.nix
    ../common/features/defaults.nix
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
      ubuntu-classic
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

  keyboard = {
    xkb_layout = "us,us";
    xkb_variant = "altgr-intl,dvp";
    xkb_options = "caps:swapescape,grp:ralt_rshift_toggle";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
