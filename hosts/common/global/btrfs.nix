{ pkgs, ... }:

{
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };

  environment.systemPackages = with pkgs; [
    compsize
    btdu
    rmlint
  ];
}
