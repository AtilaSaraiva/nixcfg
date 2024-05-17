{ pkgs, ... }:

{
  home.packages = with pkgs; [
    spotify
    zotero_7
    tdesktop
    dropbox
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
    youtube-dl
    gimp
    scrcpy
    transmission-qt
    kopia
    openconnect
    firefox
  ];
}
