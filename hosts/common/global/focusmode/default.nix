{ lib, ... }:

{
  options = {
    focusMode = lib.mkEnableOption "Whether to disable functionality to focus better.";

    gaming = {
      enable = lib.mkEnableOption "Whether to enable gaming apps like steam and lutris.";
      hardwareConfiguration = lib.mkOption {
        type = lib.types.path;
        description = "Hardware configuration file to be imported by the module.";
      };
    };
  };
  imports = [ ./chill.nix ./gaming.nix ./focus-working.nix ];
  config = {
    specialisation.focus-mode.configuration = { ... }: {
      system.nixos.tags = [ "focus-mode" ];
      focusMode = true;
    };
  };
}
