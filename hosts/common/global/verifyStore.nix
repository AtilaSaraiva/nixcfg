{
  services.fcron = {
    enable = true;
    systab = ''
      0 12 * * 1 nix-store --verify --check-contents --repair
    '';
  };
}

