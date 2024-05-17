{ pkgs, ... }:

{
  home = {
    file = {
      ".jupyter/jupyter_notebook_config.py".source = ./jupyter_notebook_config.py;
    };

    packages = [
      pkgs.python3Packages.notebook
    ];
  };
}
