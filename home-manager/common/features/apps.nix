{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zotero
    # Temporarily removing bitwarden because electron is insecure
    # bitwarden-desktop
    mpv
    buku
    oil-buku
    kdePackages.okular
    qbittorrent
    xournalpp
    obs-studio-wrapped
    inkscape-with-extensions
    blanket
    libreoffice-fresh
    yt-dlp
    gimp
    kopia
    openconnect
    klavaro
    scrcpy
    wayvnc
    wlvncc
    chromium
    calibre
    rquickshare
  ];

  programs.spotify-player.enable = true;

  # firefox esr, used in Zotero is sheets, so I am just using this temp approach
  nixpkgs.config.permittedInsecurePackages = [
    "firefox-esr-140-bin-unwrapped-140.17.0esr"
  ];
}
