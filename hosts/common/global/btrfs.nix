{ pkgs, ... }:

{
  services.btrfs.autoScrub = {
    enable = false;
    interval = "monthly";
  };

  environment.systemPackages = with pkgs; [
    compsize
    btdu
    rmlint
  ];
}
