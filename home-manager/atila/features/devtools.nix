{ pkgs, ... }:

{
  home.packages = with pkgs; [
    conda
    podman-compose
    texliveMedium
  ];
}
