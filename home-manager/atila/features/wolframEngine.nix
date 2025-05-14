{ pkgs, ... }:

{
  home.packages = with pkgs; [
    stable.wolfram-engine
  ];
}
