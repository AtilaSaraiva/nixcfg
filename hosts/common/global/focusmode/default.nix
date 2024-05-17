{ lib, ... }:

{
  options = {
    focusMode = lib.mkEnableOption "Whether to disable functionality to focus better.";
    gaming = lib.mkEnableOption "Whether to enable gaming apps like steam and lutris.";
  };
  imports = [ ./chill.nix ./gaming.nix ./focus-working.nix ];
  config = {
    specialisation.focus-mode.configuration = { ... }: {
      system.nixos.tags = [ "focus-mode" ];
      focusMode = true;
    };
  };
}
