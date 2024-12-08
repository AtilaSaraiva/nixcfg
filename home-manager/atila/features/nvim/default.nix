{ pkgs, inputs, ... }:

let
  vim-plug = pkgs.fetchFromGitHub {
    owner = "junegunn";
    repo = "vim-plug";
    rev = "ca0ae0a8b1bd6380caba2d8be43a2a19baf7dbe2";
    sha256 = "1ay2f1liya4ycf7ybiqhz02sywxkw7vhschl2kwl5hvxjahpi9p7";
  };
in
{
  home.sessionVariables.EDITOR = "nvim";

  programs.neovim.enable = true;

  home.packages = [
    pkgs.nixd
  ];

  xdg.configFile = {
    "nvim/init.lua".source = ./init.lua;
    "nvim/lua" = {
      source = ./lua;
      recursive = true;
    };
    "nvim/after" = {
      source = ./after;
      recursive = true;
    };
    "nvim/LuaSnips" = {
      source = ./LuaSnips;
      recursive = true;
    };
  };

  xdg.desktopEntries = {
    nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      comment = "Edit text files";
      exec = "nvim %F";
      icon = "nvim";
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
      terminal = true;
      type = "Application";
      categories = [
        "Utility"
        "TextEditor"
      ];
    };
  };

}
