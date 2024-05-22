{ lib, config, ... }:

{
  options.zshmarks = lib.mkOption {
    type = lib.types.str;
    default = " ";
  };

  config = {
    home.file.".bookmarks".text = ''
      /tmp|tmp
      $HOME/Files/Mega/phd|phd
    '' + config.zshmarks;
  };
}
