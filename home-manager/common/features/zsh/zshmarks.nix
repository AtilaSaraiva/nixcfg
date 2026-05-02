{ lib, config, ... }:

{
  options.zshmarks = lib.mkOption {
    type = lib.types.str;
    default = " ";
  };

  config = {
    home.file.".bookmarks".text = ''
      /tmp|tmp
      $HOME/${config.folders.annex}/phd|phd
      $HOME/${config.folders.annex}/phd/notes|note
      $HOME/${config.folders.annex}/phd/TA/EN PH 230|ta
      $HOME/${config.folders.projects}|proj
      $HOME/${config.folders.projects}/julia|jl
      $HOME/${config.folders.repos}|repos
      $HOME/${config.folders.nixcfg}|ni
      $HOME/${config.folders.annex}|an
      $HOME/${config.folders.syncthing}|sy
    '' + config.zshmarks;
  };
}
