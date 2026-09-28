{ pkgs, ... }:

{
  home.sessionVariables.EDITOR = "nvim";

  programs.neovim.enable = true;

  home.packages = with pkgs; [
    nixd
    markdown-oxide
    lsof

    # nvim-treesitter's `main` branch builds grammars at install time rather
    # than shipping them, shelling out to the tree-sitter CLI and a C compiler.
    # Without these, :TSUpdate compiles nothing and highlighting falls back to
    # the parsers bundled with Neovim itself.
    tree-sitter
    gcc
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
