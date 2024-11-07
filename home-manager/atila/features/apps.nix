{ pkgs, ... }:

{
  home.packages = with pkgs; [
    spotify
    zotero_7
    bitwarden
    mpv
    buku
    oil-buku
    libsForQt5.okular
    qbittorrent
    xournalpp
    obs-studio-wrapped
    inkscape
    blanket
    libreoffice-fresh
    yt-dlp
    gimp
    transmission-qt
    kopia
    openconnect
    firefox
    klavaro
    hakuneko
    scrcpy
    wayvnc
    wlvncc
    chromium
  ];
}
