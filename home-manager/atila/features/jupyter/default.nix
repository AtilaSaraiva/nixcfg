{ pkgs, ... }:

{
  home = {
    file = {
      ".jupyter/jupyter_notebook_config.py".source = ./jupyter_notebook_config.py;
    };

    packages = with pkgs; [
      python3Packages.notebook
      python3Packages.matplotlib
      python3Packages.numpy
    ];
  };
}
