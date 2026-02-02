{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zotero
    bitwarden-desktop
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
