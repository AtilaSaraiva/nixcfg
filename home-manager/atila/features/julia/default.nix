{ pkgs, ... }:

{
  home = {
    file = {
      ".julia/config/startup.jl".source = ./startup.jl;
      ".julia/environments" = {
      source = ./environments;
      recursive = true;
      };
    };

    packages = [
      pkgs.julia
    ];
  };
}
