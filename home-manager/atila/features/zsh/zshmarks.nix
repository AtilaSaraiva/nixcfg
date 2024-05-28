{ lib, config, ... }:

{
  options.zshmarks = lib.mkOption {
    type = lib.types.str;
    default = " ";
  };

  config = {
    home.file.".bookmarks".text = ''
      /tmp|tmp
      $HOME/Files/synced/phd|phd
      $HOME/${config.folders.projects}|proj
      $HOME/${config.folders.projects}/julia|jl
      $HOME/${config.folders.repos}|repos
      $HOME/${config.folders.nixcfg}|ni
    '' + config.zshmarks;
  };
}
