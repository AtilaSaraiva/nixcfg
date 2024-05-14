{ config, pkgs, ... }:

let
  dotfiles = config.lib.file.mkOutOfStoreSymlink "/home/atila/Files/Codigos/repos/nix-starter-config/home-manager/atila/features/qutebrowser";
in
{
  xdg.configFile."qutebrowser/autoconfig.yml".source = "${dotfiles}/autoconfig.yml";
  xdg.configFile."qutebrowser/quickmarks".source = "${dotfiles}/quickmarks";
  xdg.configFile."qutebrowser/bookmarks/urls".source = "${dotfiles}/bookmarks/urls";

  home.packages = [
    pkgs.qutebrowser
  ];
}
