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
  ];
}
