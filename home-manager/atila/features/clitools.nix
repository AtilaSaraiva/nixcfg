{pkgs, ...}:

{
  home.packages = with pkgs; [
    nmap
    htop
    clinfo
    wget
    sshfs
    udiskie
    ripgrep
    iotop
    distrobox
    ouch
    unzip
    duf
    feh
    zathura
    nixosbuild
    git-remote-gcrypt
    git-annex
    mount-zip
    fuse-archive
    spectrogram
    mediainfo
    mktorrent
    gdu
    octave # for calculating stuff
  ];
}
