{ outputs, lib, ... }:

{
  options.folders = {
    projects = lib.mkOption {
      type = lib.types.str;
      default = "Files/synced/phd/projects";
    };
    repos = lib.mkOption {
      type = lib.types.str;
      default = "Files/Codigos/repos";
    };
    nixcfg = lib.mkOption {
      type = lib.types.str;
      default = "Files/Codigos/repos/nixcfg";
    };
  };

  config = {
    nixpkgs = {
      # You can add overlays here
      overlays = [
        # Add overlays your own flake exports (from overlays and pkgs dir):
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.stable-packages

        # You can also add overlays exported from other flakes:
        # neovim-nightly-overlay.overlays.default

        # Or define it inline, for example:
        # (final: prev: {
        #   hi = final.hello.overrideAttrs (oldAttrs: {
        #     patches = [ ./change-hello-to-hi.patch ];
        #   });
        # })
      ];
      # Configure your nixpkgs instance
      config = {
        # Disable if you don't want unfree packages
        allowUnfree = true;
      };
    };

    # TODO: Set your username
    home = {
      username = lib.mkDefault "atila";
      homeDirectory = lib.mkDefault "/home/atila";
    };

    # Enable home-manager and git
    programs.home-manager.enable = true;

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  };
}
