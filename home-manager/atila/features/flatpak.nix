{ inputs, lib, ...}:

{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  services.flatpak = {
    enable = true;

    remotes = lib.mkOptionDefault [{
      name = "flathub-beta";
      location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    }];

    packages = [
      "com.github.tchx84.Flatseal"
      "md.obsidian.Obsidian"
      "us.zoom.Zoom"
    ];

    uninstallUnmanaged = true;
  };
}
