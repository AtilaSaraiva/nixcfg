{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt
    nix-index
    nix-update
    nixpkgs-review
    niv
    nix-du
  ];
}
