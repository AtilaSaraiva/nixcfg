# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: rec {
  # example = pkgs.callPackage ./example { };
  amdgpu-fan = pkgs.callPackage ./amdgpu-fan { };
  i3empty = pkgs.callPackage ./i3empty { };
  nixosbuild = pkgs.callPackage ./nixosbuild { };
  vl = pkgs.callPackage ./scripts { scriptName = "vl"; };
  vg = pkgs.callPackage ./scripts { scriptName = "vg"; };
  fl = pkgs.callPackage ./scripts { scriptName = "fl"; };
  latexit = pkgs.callPackage ./scripts {
    scriptName = "latexit";
    substitutions = {
      "$(which pdflatex)" = "${pkgs.texliveFull}/bin/pdflatex";
      "$(which pdfcrop)" = "${pkgs.texliveFull}/bin/pdfcrop";
    };
  };
  rgf = pkgs.callPackage ./scripts {
    scriptName = "rgf";
    substitutions = {
      "$(which rg)" = "${pkgs.ripgrep}/bin/rg";
      "$(which bat)" = "${pkgs.bat}/bin/bat";
    };
  };
  multissh = pkgs.callPackage ./scripts {
    scriptName = "multissh";
    substitutions = {
      "tmux" = "${pkgs.tmux}/bin/tmux";
    };
  };
  rgff = pkgs.callPackage ./scripts {
    scriptName = "rgff";
    substitutions = {
      "rgf" = "${rgf}/bin/rgf";
    };
  };
  sway-display-swap = pkgs.callPackage ./scripts { scriptName = "sway-display-swap.sh"; };
  toggleFreesync = pkgs.callPackage ./scripts { scriptName = "toggleFreesync"; };

  #aftergameopen = pkgs.callPackage ./scripts { scriptName = "aftergameopen"; };
  #animatedWallpaper = pkgs.callPackage ./scripts { scriptName = "animatedWallpaper"; };
  #bookmarkadd = pkgs.callPackage ./scripts { scriptName = "bookmarkadd"; };
  #energyPlan = pkgs.callPackage ./scripts { scriptName = "energyPlan"; };
  #i3empty = pkgs.callPackage ./scripts { scriptName = "i3empty.py"; };
  #kill4game = pkgs.callPackage ./scripts { scriptName = "kill4game"; };
  #oguriWallpaper = pkgs.callPackage ./scripts { scriptName = "oguriWallpaper"; };
  #pmenu_g = pkgs.callPackage ./scripts { scriptName = "pmenu_g"; };
  #portSwitch = pkgs.callPackage ./scripts { scriptName = "portSwitch"; };
  #remote = pkgs.callPackage ./scripts { scriptName = "remote"; };
  #bigsteam = pkgs.callPackage ./scripts { scriptName = "bigsteam"; };
}
