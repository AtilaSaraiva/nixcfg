# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  amdgpu-fan = pkgs.callPackage ./amdgpu-fan { };

  aftergameopen = pkgs.callPackage ./scripts { scriptName = "aftergameopen"; };
  animatedWallpaper = pkgs.callPackage ./scripts { scriptName = "animatedWallpaper"; };
  bookmarkadd = pkgs.callPackage ./scripts { scriptName = "bookmarkadd"; };
  energyPlan = pkgs.callPackage ./scripts { scriptName = "energyPlan"; };
  i3empty = pkgs.callPackage ./scripts { scriptName = "i3empty.py"; };
  kill4game = pkgs.callPackage ./scripts { scriptName = "kill4game"; };
  oguriWallpaper = pkgs.callPackage ./scripts { scriptName = "oguriWallpaper"; };
  pmenu_g = pkgs.callPackage ./scripts { scriptName = "pmenu_g"; };
  portSwitch = pkgs.callPackage ./scripts { scriptName = "portSwitch"; };
  remote = pkgs.callPackage ./scripts { scriptName = "remote"; };
  sway-display-swap = pkgs.callPackage ./scripts { scriptName = "sway-display-swap.sh"; };
  toggleFreesync = pkgs.callPackage ./scripts { scriptName = "toggleFreesync"; };
  bigsteam = pkgs.callPackage ./scripts { scriptName = "bigsteam"; };
}
