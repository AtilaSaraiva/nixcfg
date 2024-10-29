{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt
    nix-index
    nix-update
    nixpkgs-review
    nix-prefetch-git
    nix-prefetch-github
    niv
    nix-du
  ];
}
