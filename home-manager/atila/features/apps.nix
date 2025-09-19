{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zotero_7
    bitwarden
    mpv
    buku
    oil-buku
    kdePackages.okular
    qbittorrent
    xournalpp
    obs-studio-wrapped
    inkscape
    blanket
    libreoffice-fresh
    yt-dlp
    gimp
    transmission_4-qt
    kopia
    openconnect
    firefox
    klavaro
    hakuneko
    scrcpy
    wayvnc
    wlvncc
    chromium
    calibre
    homebank
  ];

  programs.spotify-player.enable = true;
}
