# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    obs-studio-wrapped = prev.wrapOBS.override { inherit (prev) obs-studio; } {
      plugins = with prev.obs-studio-plugins; [
        obs-gstreamer
        obs-pipewire-audio-capture
        obs-vaapi
        obs-vkcapture
        wlrobs
      ];
    };
    #gamescope = prev.gamescope.overrideAttrs (oldAttrs: rec {
      #version = "3.13.16";
      #src = prev.fetchFromGitHub {
        #owner = "ValveSoftware";
        #repo = "gamescope";
        #rev = "refs/tags/3.13.16";
        #fetchSubmodules = true;
        #hash = "sha256-VxZSRTqsEyEc8C2gNdRxik3Jx1NxB9ktQ3ALUFkDjo0=";
      #};
    #});
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
