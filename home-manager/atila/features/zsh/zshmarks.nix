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
      $HOME/Files/synced/phd/notes|note
      $HOME/Files/synced/phd/classes/PHYS 580 computational physics|ta
      $HOME/${config.folders.projects}|proj
      $HOME/${config.folders.projects}/julia|jl
      $HOME/${config.folders.repos}|repos
      $HOME/${config.folders.nixcfg}|ni
      $HOME/${config.folders.annex}|an
      $HOME/${config.folders.syncthing}|sy
    '' + config.zshmarks;
  };
}
