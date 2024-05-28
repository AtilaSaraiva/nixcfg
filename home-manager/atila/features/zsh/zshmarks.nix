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
      $HOME/Files/synced/phd/projects|proj
      $HOME/Files/synced/phd/projects/julia|jl
    '' + config.zshmarks;
  };
}
