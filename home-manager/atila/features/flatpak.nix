{ inputs, lib, ...}:

{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
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
    ];

    uninstallUnmanaged = true;
  };
}
