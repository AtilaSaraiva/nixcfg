{ inputs, pkgs, lib, ... }:

{
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
    package = pkgs.nix;
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      trusted-users = [ "@wheel" ];
      auto-optimise-store = true;
      trusted-public-keys = [
        "binarycache.com:F14RK+znP8o15IWh7ObV/gGDqif1cfddFbLHWh6BgCI="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "http://juroscomposto:5000/"
      ];
    };

    # Opinionated: make flake registry and nix path match nix run ripgrep#nixpkgs defaultUserShellflake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };
}
